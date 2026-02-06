//
//  SingleBookView.swift
//  GutenBooks
//
//  Created by Viktor Zavhorodnii on 03/02/2026.
//

import SwiftUI
import Kingfisher

struct SingleBookView: View {
    let book: Book
    let isShownFromFavorites: Bool
    
    @Environment(BooksStore.self) private var store
    @State private var showRemoveFavoriteConfirm: Bool = false
    
    var body: some View {
        HStack {
            KFImage(book.coverURL)
                .placeholder {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            Image(systemName: "book.closed")
                                .foregroundStyle(.secondary)
                        )
                }
                .cancelOnDisappear(true)
                .resizable()
                .frame(width: 64, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(book.authors.joined(separator: ", "))
                    .font(.default)
                    .foregroundStyle(.secondary)
                if isShownFromFavorites {
                    Text(book.isRead ? "Completed" : "Reading")
                        .font(.default)
                        .foregroundStyle(.tertiary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Button {
                if isShownFromFavorites && book.isFavorite {
                    showRemoveFavoriteConfirm = true
                } else {
                    store.toggleFavorite(book)
                }
            } label: {
                Image(systemName: book.isFavorite ? "heart.fill" : "heart")
                    .foregroundStyle(book.isFavorite ? Color.accentColor : .secondary)
            }
            .imageScale(.large)
            .buttonStyle(.plain)
            .confirmationDialog(
                "Are you sure",
                isPresented: $showRemoveFavoriteConfirm,
                titleVisibility: .hidden
            ) {
                Button("Remove from favorites", role: .destructive) {
                    store.toggleFavorite(book)
                }
            } message: {
                Text("Book will be removed from favorites.")
            }
        }
    }
}

#Preview("Regular", traits: .sizeThatFitsLayout) {
    let book = Book.sampleData[0]
    let previewStore = BooksStore(service: GutenBooksService(), initialBooks: [book])
    SingleBookView(book: book, isShownFromFavorites: false)
        .environment(previewStore)
}

#Preview("Favorites", traits: .sizeThatFitsLayout) {
    let book = Book.sampleData[0]
    let previewStore = BooksStore(service: GutenBooksService(), initialBooks: [book])
    SingleBookView(book: book, isShownFromFavorites: true)
        .environment(previewStore)
}
