//
//  RootTabView.swift
//  GutenBooks
//
//  Created by Viktor Zavhorodnii on 03/02/2026.
//

import SwiftUI

struct RootTabView: View {
    private let store: BooksStore
    
    init() {
        let service = GutenBooksService()
        let store = BooksStore(service: service)
        
        self.store = store
    }
    
    var body: some View {
        TabView {
            Tab("Books", systemImage: "books.vertical") {
                BooksView()
                    .accessibilityIdentifier("booksTabRoot")
            }
            Tab("Favorites", systemImage: "heart") {
                FavoritesBooksView()
                    .accessibilityIdentifier("favoritesTabRoot")
            }
            
        }
        .environment(store)
        .task {
            await store.loadInitialIfNeeded()
        }
    }
}

#Preview {
    RootTabView()
}
