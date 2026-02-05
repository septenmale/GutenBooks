//
//  BookStore.swift
//  GutenBooks
//
//  Created by Viktor Zavhorodnii on 04/02/2026.
//

import Foundation

@Observable
final class BooksStore {
    private let service: GutenBooksServiceProtocol
    
    private(set) var books: [Book] = []
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String? = nil
    
    private var nextURL: URL? = nil
    private var hasLoadedInitial: Bool = false
    private var isLoadingNext: Bool = false
    
    var favoritesBooks: [Book] {
        books.filter { $0.isFavorite }
    }
    
    
    init(service: GutenBooksServiceProtocol, initialBooks: [Book] = []) {
        self.service = service
        self.books = initialBooks
    }
    
    func toggleFavorite(_ book: Book) {
        book.isFavorite.toggle()
    }
    
    func toggleIsRead(_ book: Book) {
        book.isRead.toggle()
    }
    
    func loadInitialIfNeeded() async {
        guard !hasLoadedInitial else { return }
        hasLoadedInitial = true
        await loadInitial()
    }
    
    func reload() async {
        guard !isLoading else { return }
        await loadInitial()
    }
    
    private func loadInitial() async {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        do {
            let page = try await service.fetchBooksPage(nextURL: nil)
            
            books = page.results.map { response in
                Book(from: response)
            }
            nextURL = page.nextURL
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Failed to load books"
        }
    }
    
    func loadNextIfNeeded(currentBook: Book) async {
        guard let nextURL else { return }
        guard !isLoadingNext else { return }
        
        let threshold = 12
        guard let index = books.firstIndex(where: { $0.id == currentBook.id }) else { return }
        guard index >= books.count - threshold else { return }
        
        isLoadingNext = true
        defer { isLoadingNext = false }
        do {
            let page = try await service.fetchBooksPage(nextURL: nextURL)
            
            let newBooks = page.results.map { response in
                Book(from: response)
            }
            books += newBooks
            
            self.nextURL = page.nextURL
        } catch {
        }
    }
}
