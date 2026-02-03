//
//  Book+Sample.swift
//  GutenBooks
//
//  Created by Viktor Zavhorodnii on 03/02/2026.
//

import Foundation

extension Book {
    static let sampleData: [Book] = [
        Book(
            id: 1,
            title: "Pride and Prejudice",
            authors: ["Jane Austen"],
            summary: "A classic novel about manners, upbringing, morality and marriage.",
            languages: ["en"],
            downloadCount: 123456,
            coverURL: URL(string: "https://www.gutenberg.org/cache/epub/1342/pg1342.cover.medium.jpg"),
            isFavorite: false
        ),
        Book(
            id: 2,
            title: "Moby-Dick",
            authors: ["Herman Melville"],
            summary: "The narrative of Captain Ahab’s obsessive quest to defeat the white whale.",
            languages: ["en"],
            downloadCount: 98765,
            coverURL: nil,
            isFavorite: true
        )
    ]
}
