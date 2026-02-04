//
//  BooksView.swift
//  GutenBooks
//
//  Created by Viktor Zavhorodnii on 03/02/2026.
//

import SwiftUI

struct BooksView: View {
    @State private var searchText: String = ""
    @Binding var books: [Book]
    
    var body: some View {
        NavigationStack {
            List($books) { $book in
                NavigationLink {
                    BookDetailView(book: $book)
                } label: {
                    SingleBookView(book: $book, isShownFromFavorites: false)
                }
            }
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer,
                prompt: "Search titles or authors"
            )
        }
        .navigationTitle("Books")
    }
}

#Preview {
    @Previewable @State var book = Book.sampleData
    NavigationStack {
        BooksView(books: $book)
    }
}
