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
                    
                    List {
                        Section {
                            ForEach(store.favoritesBooks) { book in
                                NavigationLink {
                                    BookDetailView(book: book)
                                } label: {
                                    SingleBookView(book: book, isShownFromFavorites: true)
                                }
                                .swipeActions(edge: .trailing) {
                                    Button {
                                        store.toggleIsRead(book)
                                    } label: {
                                        book.isRead
                                        ? Label("Mark Unread", systemImage: "arrow.uturn.backward.circle")
                                        : Label("Mark Read", systemImage: "checkmark.circle.fill")
                                    }
                                    .tint(book.isRead ? .orange : .green)
                                }
                            }
                            
                        } footer: {
                            let total = store.favoritesBooks.count
                            let read = store.favoritesBooks.filter { $0.isRead }.count
                            Text("Total count: \(total), completed: \(read)")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.bottom)
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
