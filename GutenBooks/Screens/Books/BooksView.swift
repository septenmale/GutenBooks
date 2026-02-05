//
//  BooksView.swift
//  GutenBooks
//
//  Created by Viktor Zavhorodnii on 03/02/2026.
//

import SwiftUI

struct BooksView: View {
    let viewModel: BooksViewModel
    
    //TODO: Add loader while loading in progress 
    var body: some View {
        NavigationStack {
            List(viewModel.allBooks) { book in
                NavigationLink {
                    BookDetailView(book: book)
                } label: {
                    SingleBookView(book: book, isShownFromFavorites: false)
                }
                // task или onAppear
                .task {
                    await viewModel.loadNextIfNeeded(currentBook: book)
                }
            }
            .navigationTitle("Books")
        }
    }
}

#Preview {
    let service = GutenBooksService()
    let store = BooksStore(service: service)
    store.books = Book.sampleData
    let vm = BooksViewModel(store: store)
    
   return BooksView(viewModel: vm)
}
