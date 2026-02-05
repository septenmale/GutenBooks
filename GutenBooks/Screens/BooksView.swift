//
//  BooksView.swift
//  GutenBooks
//
//  Created by Viktor Zavhorodnii on 03/02/2026.
//

import SwiftUI

struct BooksView: View {
    @Environment(BooksStore.self) private var store
    
    private var shouldShowProgress: Bool {
        store.isLoading && store.books.isEmpty
    }
    
    private var shouldShowInitialError: Bool {
        store.errorMessage != nil && store.books.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if shouldShowProgress {
                    ProgressView()
                        .controlSize(.large)
                } else if shouldShowInitialError {
                    EmptyStateView(
                        icon: "wifi.exclamationmark",
                        title: "Couldn't load books",
                        subtitle: "Please try again later.",
                        buttonTitle: "Retry",
                        buttonAction: {
                            Task { await store.reload() }
                        }
                    )
                } else {
                    List(store.books) { book in
                        NavigationLink {
                            BookDetailView(book: book)
                        } label: {
                            SingleBookView(book: book, isShownFromFavorites: false)
                        }
                        .task {
                            await store.loadNextIfNeeded(currentBook: book)
                        }
                    }
                    .accessibilityIdentifier("booksList")
                }
            }
            .navigationTitle("Books")
        }
    }
}

#Preview {
    let books = Book.sampleData
    let previewStore = BooksStore(service: GutenBooksService(), initialBooks: books)
    BooksView()
        .environment(previewStore)
}
