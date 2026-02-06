//
//  FavouritesBooksView.swift
//  GutenBooks
//
//  Created by Viktor Zavhorodnii on 03/02/2026.
//

import SwiftUI

struct FavoritesBooksView: View {
    @Bindable var  viewModel: FavoritesBooksViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isEmpty {
                    EmptyStateView(
                        icon: "heart",
                        title: "No favorites yet",
                        subtitle: "Tap the heart on any book to add it to your collection and see it here."
                    )
                } else {
                    List {
                        switch viewModel.sortMode {
                        case .defaultOrder, .titleAsc:
                            ForEach(viewModel.flatItems) { book in
                                FavoriteBookRow(book: book,
                                                onToggleRead: { viewModel.toggleIsRead(book) })
                            }
                        case .readStatus:
                            ForEach(viewModel.readStatusSections) { section in
                                Section(section.header) {
                                    ForEach(section.books) { book in
                                        FavoriteBookRow(book: book,
                                                        onToggleRead: { viewModel.toggleIsRead(book) })
                                    }
                                }
                            }
                        case .authorsSections:
                            ForEach(viewModel.authorSections) { section in
                                Section(section.header) {
                                    ForEach(section.books) { book in
                                        FavoriteBookRow(book: book,
                                                        onToggleRead: { viewModel.toggleIsRead(book) })
                                    }
                                }
                            }
                        }
                        
                        Section { EmptyView() } footer: {
                            Text(viewModel.footerText)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.bottom)
                        }
                    }
                    .accessibilityIdentifier("favoritesList")
                }
            }
            .navigationTitle("Favorites")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("Sort", selection: Binding(
                            get: { viewModel.sortMode },
                            set: { viewModel.sortMode = $0 }
                        )) {
                            ForEach(FavoritesBooksViewModel.SortMode.allCases) { mode in
                                Text(mode.title)
                                    .tag(mode)
                            }
                        }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
        }
    }
}

private struct FavoriteBookRow: View {
    let book: Book
    let onToggleRead: () -> Void
    
    var body: some View {
        NavigationLink {
            BookDetailView(book: book)
        } label: {
            SingleBookView(book: book, isShownFromFavorites: true)
        }
        .swipeActions(edge: .trailing) {
            Button {
                onToggleRead()
            } label: {
                book.isRead
                ? Label("Mark Unread", systemImage: "arrow.uturn.backward.circle")
                : Label("Mark Read", systemImage: "checkmark.circle.fill")
            }
            .tint(book.isRead ? .orange : .green)
        }
    }
}

#Preview {
    let books = Book.sampleData
    let previewStore = BooksStore(service: GutenBooksService(), initialBooks: books)
    let vm = FavoritesBooksViewModel(store: previewStore)
    FavoritesBooksView(viewModel: vm)
        .environment(previewStore)
}
