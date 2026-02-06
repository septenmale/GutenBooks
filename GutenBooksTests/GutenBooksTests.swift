//
//  GutenBooksTests.swift
//  GutenBooksTests
//
//  Created by Viktor Zavhorodnii on 03/02/2026.
//

import XCTest
@testable import GutenBooks

@MainActor
final class GutenBooksTests: XCTestCase {
    
    func testLoadInitialIfNeededSuccess() async {
        // Given
        let page = BooksPageResponse(
            count: 2,
            next: "https://gutendex.com/books?page=2",
            results: [
                makeBookResponse(id: 1, title: "Book 1"),
                makeBookResponse(id: 2, title: "Book 2")
            ]
        )
        
        let service = GutenBooksServiceSpy(stubs: [.success(page)])
        let store = BooksStore(service: service)
        
        // When
        await store.loadInitialIfNeeded()
        
        // Then
        XCTAssertEqual(service.fetchCalls.count, 1)
        XCTAssertFalse(store.isLoading)
        XCTAssertNil(store.errorMessage)
        XCTAssertEqual(store.books.count, 2)
        XCTAssertEqual(store.books[0].id, 1)
        XCTAssertEqual(store.books[1].id, 2)
    }
    
    
    func testLoadInitialIfNeededFailure() async {
        // Given
        let service = GutenBooksServiceSpy(stubs: [.failure(StubError())])
        let store = BooksStore(service: service)
        
        // When
        await store.loadInitialIfNeeded()
        
        // Then
        XCTAssertEqual(service.fetchCalls.count, 1)
        XCTAssertFalse(store.isLoading)
        XCTAssertTrue(store.books.isEmpty)
        XCTAssertNotNil(store.errorMessage)
    }
    
    func testLoadInitialIfNeededCalledTwice() async {
        // Given
        let page = BooksPageResponse(
            count: 1,
            next: nil,
            results: [
                makeBookResponse(id: 1, title: "Book 1")
            ]
        )
        
        let service = GutenBooksServiceSpy(stubs: [.success(page)])
        let store = BooksStore(service: service)
        
        // When
        await store.loadInitialIfNeeded()
        await store.loadInitialIfNeeded()
        
        // Then
        XCTAssertEqual(service.fetchCalls.count, 1)
        XCTAssertEqual(store.books.count, 1)
        XCTAssertEqual(store.books[0].id, 1)
    }
    
    func testReloadAfterFailureRetriesAndLoadsBooks() async {
        // Given
        let page = BooksPageResponse(
            count: 1,
            next: nil,
            results: [makeBookResponse(id: 10, title: "Recovered")]
        )
        
        let service = GutenBooksServiceSpy(stubs: [
            .failure(StubError()),
            .success(page)
        ])
        
        let store = BooksStore(service: service)
        
        // When
        await store.loadInitialIfNeeded()
        
        // Then
        XCTAssertEqual(service.fetchCalls.count, 1)
        XCTAssertNotNil(store.errorMessage)
        XCTAssertTrue(store.books.isEmpty)
        
        // When
        await store.reload()
        
        // Then
        XCTAssertEqual(service.fetchCalls.count, 2)
        XCTAssertNil(store.errorMessage)
        XCTAssertEqual(store.books.count, 1)
        XCTAssertEqual(store.books[0].id, 10)
    }
    
    func testReloadDoesNotStartIfLoadingIsInProgress() async {
        // Given
        let page = BooksPageResponse(
            count: 1,
            next: nil,
            results: [makeBookResponse(id: 1, title: "Book 1")]
        )
        
        let service = GutenBooksServiceSpy(stubs: [
            .delayedSuccess(page, delay: 300_000_000)
        ])
        
        let store = BooksStore(service: service)
        
        // When
        let loadTask = Task {
            await store.loadInitialIfNeeded()
        }
        
        try? await Task.sleep(nanoseconds: 50_000_000)
        
        await store.reload()
        
        _ = await loadTask.value
        
        // Then
        XCTAssertEqual(service.fetchCalls.count, 1)
        XCTAssertEqual(store.books.count, 1)
    }
    
    func testLoadNextIfNeededAppendsNextPageWhenNearEnd() async {
        // Given
        let initialPage = BooksPageResponse(
            count: 15,
            next: "https://gutendex.com/books?page=2",
            results: (1...15).map { id in
                makeBookResponse(id: id, title: "Book \(id)")
            }
        )
        
        let nextPage = BooksPageResponse(
            count: 17,
            next: nil,
            results: [
                makeBookResponse(id: 16, title: "Book 16"),
                makeBookResponse(id: 17, title: "Book 17")
            ]
        )
        
        let service = GutenBooksServiceSpy(stubs: [
            .success(initialPage),
            .success(nextPage)
        ])
        let store = BooksStore(service: service)
        
        // When
        await store.loadInitialIfNeeded()
        
        let currentBook = store.books.last!
        await store.loadNextIfNeeded(currentBook: currentBook)
        
        // Then
        XCTAssertEqual(service.fetchCalls.count, 2)
        XCTAssertNil(store.errorMessage)
        XCTAssertEqual(store.books.count, 17)
        XCTAssertEqual(store.books[15].id, 16)
        XCTAssertEqual(store.books[16].id, 17)
    }
    
    private func makeBookResponse(id: Int, title: String) -> BookResponse {
        BookResponse(
            id: id,
            title: title,
            authors: [AuthorResponse(name: "Author \(id)")],
            summaries: ["Summary \(id)"],
            languages: ["en"],
            bookshelves: [],
            downloadCount: 100 + id,
            formats: ["image/jpeg": "https://example.com/\(id).jpg"]
        )
    }
    
    private final class GutenBooksServiceSpy: GutenBooksServiceProtocol {
        enum Stub {
            case success(BooksPageResponse)
            case failure(Error)
            case delayedSuccess(BooksPageResponse, delay: UInt64)
        }
        
        private(set) var fetchCalls: [URL?] = []
        private var stubs: [Stub]
        
        init(stubs: [Stub]) {
            self.stubs = stubs
        }
        
        func fetchBooksPage(nextURL: URL?) async throws -> BooksPageResponse {
            fetchCalls.append(nextURL)
            
            guard !stubs.isEmpty else {
                throw StubError()
            }
            
            let stub = stubs.removeFirst()
            switch stub {
            case .success(let page):
                return page
            case .failure(let error):
                throw error
            case .delayedSuccess(let page, let delay):
                try await Task.sleep(nanoseconds: delay)
                return page
            }
        }
    }
    
    private struct StubError: LocalizedError {
        var errorDescription: String? { "Stub error" }
    }
}

