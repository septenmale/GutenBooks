//
//  BooksViewModel.swift
//  GutenBooks
//
//  Created by Viktor Zavhorodnii on 05/02/2026.
//

final class BooksViewModel {
    private let store: BooksStore
    
    init(store: BooksStore) {
        self.store = store
    }
    
    var allBooks: [Book] {
        store.books
    }
    
    var isLoading: Bool { store.isLoading }
    
    var hasError: Bool { store.errorMessage != nil }
    
    var shouldShowProgress: Bool {
        isLoading && allBooks.isEmpty
    }
    
    var shouldShowInitialError: Bool {
        hasError && allBooks.isEmpty
    }
    
    func reload() async {
        await store.reload()
    }
    
    func loadNextIfNeeded(currentBook: Book) async {
        await store.loadNextIfNeeded(currentBook: currentBook)
    }
}
