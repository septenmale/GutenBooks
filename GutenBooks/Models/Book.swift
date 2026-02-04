//
//  Book.swift
//  GutenBooks
//
//  Created by Viktor Zavhorodnii on 03/02/2026.
//

import Foundation

struct Book: Identifiable {
    let id: Int
    let title: String
    let authors: [String]
    let summary: String?
    let languages: [String]
    let bookshelves: [String]
    let downloadCount: Int
    let coverURL: URL?
    var isFavorite: Bool
}

extension Book {
    init(from response: BookResponse) {
        id = response.id
        title = response.title
        authors = response.authors.map(\.name)
        summary = response.summaries.first
        languages = response.languages
        bookshelves = Array(response.bookshelves.keys)
        downloadCount = response.downloadCount
        coverURL = URL(string: response.formats["image/jpeg"] ?? "")
        isFavorite = false
    }
}
