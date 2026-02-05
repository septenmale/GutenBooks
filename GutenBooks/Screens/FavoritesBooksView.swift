//
//  FavouritesBooksView.swift
//  GutenBooks
//
//  Created by Viktor Zavhorodnii on 03/02/2026.
//

import SwiftUI

struct FavoritesBooksView: View {
    @Environment(BooksStore.self) private var store
    
    var body: some View {
        NavigationStack {
            Group {
                if store.favoritesBooks.isEmpty {
                    EmptyStateView(
                        icon: "heart",
                        title: "No favorites yet",
                        subtitle: "Tap the heart on any book to add it to your collection and see it here."
                    )
                } else {
                    List(store.favoritesBooks) { book in
                        NavigationLink {
                            BookDetailView(book: book)
                        } label: {
                            SingleBookView(book: book, isShownFromFavorites: true)
                        }
                    }
                    .accessibilityIdentifier("favoritesList")
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    let books = Book.sampleData
    let previewStore = BooksStore(service: GutenBooksService(), initialBooks: books)
    FavoritesBooksView()
        .environment(previewStore)
}
