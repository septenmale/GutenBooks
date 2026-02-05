//
//  FavouritesBooksView.swift
//  GutenBooks
//
//  Created by Viktor Zavhorodnii on 03/02/2026.
//

import SwiftUI

struct FavoritesBooksView: View {
    let viewModel: FavoritesBooksViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.favoriteBooks.isEmpty {
                    EmptyStateView(
                        icon: "heart",
                        title: "No favorites yet",
                        subtitle: "Tap the heart on any book to add it to your collection and see it here."
                    )
                } else {
                    List(viewModel.favoriteBooks) { book in
                        NavigationLink {
                            BookDetailView(book: book)
                        } label: {
                            SingleBookView(book: book, isShownFromFavorites: true)
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    let service = GutenBooksService()
    let store = BooksStore(service: service)
    store.books = Book.sampleData
    let vm = FavoritesBooksViewModel(store: store)
    
    return FavoritesBooksView(viewModel: vm)
}
