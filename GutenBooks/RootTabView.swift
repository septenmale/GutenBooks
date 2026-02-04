//
//  RootTabView.swift
//  GutenBooks
//
//  Created by Viktor Zavhorodnii on 03/02/2026.
//

import SwiftUI

struct RootTabView: View {
    @State private var books: [Book] = Book.sampleData
    
    var body: some View {
        TabView {
            Tab("Books", systemImage: "books.vertical") {
                BooksView(books: $books)
            }
            Tab("Favorites", systemImage: "heart") {
                FavoritesBooksView(books: $books)
            }

        }
    }
}

#Preview {
    RootTabView()
}
