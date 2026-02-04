//
//  FavouritesBooksView.swift
//  GutenBooks
//
//  Created by Viktor Zavhorodnii on 03/02/2026.
//

import SwiftUI
// TODO: Figure out maybe the store will be better alternative for array prersistance.
struct FavoritesBooksView: View {
    @Binding var books: [Book]
    @State private var sortOption: FavoritesSortOption = .nameAsc

    private enum FavoritesSortOption {
        case nameAsc
        case nameDesc
        case downloadsDesc
        case downloadsAsc
    }
    
    var body: some View {
        // TODO: Move filtering logic into ViewModel when it's introduced
        let favoriteIndices = books.indices.filter { books[$0].isFavorite }
        
        NavigationStack {
            Group {
                if favoriteIndices.isEmpty {
                    EmptyStateView(icon: "heart",
                                   title: "No favorites yet",
                                   subtitle: "Tap the heart on any book to add it to your collection and see it here.")
                } else {
                    List(favoriteIndices, id: \.self) { index in
                        NavigationLink(value: index) {
                            SingleBookView(book: $books[index], isShownFromFavorites: true)
                        }
                    }
                    .navigationDestination(for: Int.self) { index in
                        BookDetailView(book: $books[index])
                    }                }
            }
            .navigationTitle("Favorites")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        // TODO: Apply sorting in ViewModel when introduced
                        Button(action: { sortOption = .nameAsc }) {
                            Text("Name (A–Z)")
                        }
                        Button(action: { sortOption = .nameDesc }) {
                            Text("Name (Z–A)")
                        }
                        Divider()
                        Button(action: { sortOption = .downloadsDesc }) {
                            Text("Downloads (High → Low)")
                        }
                        Button(action: { sortOption = .downloadsAsc }) {
                            Text("Downloads (Low → High)")
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle")
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var book = Book.sampleData
    NavigationStack {
        FavoritesBooksView(books: $book)
    }
}
