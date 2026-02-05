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

    // considering
    var isLoading: Bool { store.isLoading }
    var errorMessage: String? { store.errorMessage }

    // considering
    func reload() async {
        await store.reload()
    }

    func loadNextIfNeeded(currentBook: Book) async {
        await store.loadNextIfNeeded(currentBook: currentBook)
    }
}
