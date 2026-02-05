//
//  RootTabView.swift
//  GutenBooks
//
//  Created by Viktor Zavhorodnii on 03/02/2026.
//

import SwiftUI

struct RootTabView: View {
    private let store: BooksStore
    private let favoritesVM: FavoritesBooksViewModel
    private let booksVM: BooksViewModel
    
    init() {
        let service = GutenBooksService()
        let store = BooksStore(service: service)
        let favoritesVM = FavoritesBooksViewModel(store: store)
        let booksVM = BooksViewModel(store: store)
        self.store = store
        self.favoritesVM = favoritesVM
        self.booksVM = booksVM
    }
    
    var body: some View {
        TabView {
            Tab("Books", systemImage: "books.vertical") {
                BooksView(viewModel: booksVM)
                    .accessibilityIdentifier("booksTabRoot")
            }
            Tab("Favorites", systemImage: "heart") {
                FavoritesBooksView(viewModel: favoritesVM)
                    .accessibilityIdentifier("favoritesTabRoot")
            }
            
        }
        .task {
            await store.loadInitialIfNeeded()
        }
    }
}

#Preview {
    RootTabView()
}
