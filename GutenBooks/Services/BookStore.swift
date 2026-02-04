//
//  BookStore.swift
//  GutenBooks
//
//  Created by Viktor Zavhorodnii on 04/02/2026.
//

import Foundation

@MainActor
@Observable
final class BooksStore {
    private let service: GutenBooksProtocol
    
    var books: [Book] = []
    
    // For UI handling – delete if no use
    var isLoading: Bool = false
    var isLoadingNext: Bool = false
    var errorMessage: String? = nil
    
    // Pagination
    private var nextURL: URL? = nil
    private var hasLoadedInitial: Bool = false
    
    init(service: GutenBooksProtocol) {
        self.service = service
    }
    
    func loadInitialIfNeeded() async {
        guard !hasLoadedInitial else { return }
        hasLoadedInitial = true
        await loadInitial()
    }
    
    // Will be suitable for reload button
    func reload() async {
        hasLoadedInitial = true
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
