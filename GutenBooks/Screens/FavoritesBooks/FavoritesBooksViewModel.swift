//
//  FavoritesBooksViewModel.swift
//  GutenBooks
//
//  Created by Viktor Zavhorodnii on 04/02/2026.
//

import Observation

final class FavoritesBooksViewModel {
    // protocol?
    private let store: BooksStore
    
    init(store: BooksStore) {
        self.store = store
    }
    
    var favoriteBooks: [Book] {
        store.books.filter { $0.isFavorite }
    }
}
