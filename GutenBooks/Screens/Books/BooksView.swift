//
//  BooksView.swift
//  GutenBooks
//
//  Created by Viktor Zavhorodnii on 03/02/2026.
//

import SwiftUI

struct BooksView: View {
    let viewModel: BooksViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.shouldShowProgress {
                    ProgressView()
                        .controlSize(.large)
                } else if viewModel.shouldShowInitialError {
                    EmptyStateView(
                        icon: "wifi.exclamationmark",
                        title: "Couldn't load books",
                        subtitle: "Please try again later.",
                        buttonTitle: "Retry",
                        buttonAction: {
                            Task { await viewModel.reload() }
                        }
                    )
                } else {
                    List(viewModel.allBooks) { book in
                        NavigationLink {
                            BookDetailView(book: book)
                        } label: {
                            SingleBookView(book: book, isShownFromFavorites: false)
                        }
                        .task {
                            await viewModel.loadNextIfNeeded(currentBook: book)
                        }
                    }
                }
            }
            .navigationTitle("Books")
        }
    }
}

#Preview {
    let service = GutenBooksService()
    let store = BooksStore(service: service, initialBooks: Book.sampleData)
    let vm = BooksViewModel(store: store)
    
    BooksView(viewModel: vm)
}
