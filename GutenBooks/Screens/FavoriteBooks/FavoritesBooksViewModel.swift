//
//  FavoritesBooksViewModel.swift
//  GutenBooks
//
//  Created by Viktor Zavhorodnii on 05/02/2026.
//

import Observation
import Foundation

@Observable
final class FavoritesBooksViewModel {
    
    private let store: BooksStore
    private var favorites: [Book] {
        store.favoritesBooks
    }
    
    enum SortMode: String, CaseIterable, Identifiable {
        case defaultOrder
        case titleAsc
        case authorsSections
        case readStatus
        
        var id: String { rawValue }
        var title: String {
            switch self {
            case .defaultOrder: return "Default"
            case .titleAsc: return "Title"
            case .authorsSections: return "Author"
            case .readStatus: return "Read status"
            }
        }
    }
    
    struct SectionModel: Identifiable {
        let header: String
        let books: [Book]
        var id: String { header }
    }
    
    var sortMode: SortMode = .defaultOrder
    
    var flatItems: [Book] {
        switch sortMode {
        case .defaultOrder:
            return favorites
        case .titleAsc:
            return favorites.sorted {
                $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            }
        case .readStatus:
            return []
        case .authorsSections:
            return []
        }
    }
    
    var authorSections: [SectionModel] {
        guard sortMode == .authorsSections else { return [] }
        let grouped = Dictionary(grouping: favorites) { (book: Book) in
            let header = book.authors.isEmpty ? "Unknown Author" : book.authors.joined(separator: " & ")
            return header
        }
        return grouped
            .map { key, value in
                SectionModel(
                    header: key,
                    books: value.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
                )
            }
            .sorted { $0.header.localizedCaseInsensitiveCompare($1.header) == .orderedAscending }
    }
    
    var readStatusSections: [SectionModel] {
        guard sortMode == .readStatus else { return [] }
        let read = favorites
            .filter { $0.isRead }
            .sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        let unread = favorites
            .filter { !$0.isRead }
            .sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        var result: [SectionModel] = []
        if !unread.isEmpty {
            result.append(SectionModel(header: "Reading", books: unread))
        }
        if !read.isEmpty {
            result.append(SectionModel(header: "Completed", books: read))
        }
        return result
    }
    
    var isEmpty: Bool {
        favorites.isEmpty
    }
    
    var footerText: String {
        let total = favorites.count
        let read = favorites.filter { $0.isRead }.count
        return "Total count: \(total), completed: \(read)"
    }
    
    init(store: BooksStore) {
        self.store = store
    }
    
    func toggleIsRead(_ book: Book) {
        store.toggleIsRead(book)
    }
}
