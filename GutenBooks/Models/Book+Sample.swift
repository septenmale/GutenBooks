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
            bookshelves: ["British literature", "Novels", "Romance", "Harvard classic"],
            downloadCount: 123456,
            coverURL: URL(string: "https://www.gutenberg.org/cache/epub/1342/pg1342.cover.medium.jpg"),
            isFavorite: false,
            isRead: false
        ),
        Book(
            id: 2,
            title: "How to win friends",
            authors: ["Dale Carnaegi"],
            summary: "A classic guide how to win friends.",
            languages: ["en"],
            bookshelves: ["Novel", "Ever listings", "Parade"],
            downloadCount: 45565,
            coverURL: URL(string: "https://www.gutenberg.org/cache/epub/2701/pg2701.cover.medium.jpg"),
            isFavorite: true,
            isRead: false
        ),
        Book(
            id: 3,
            title: "Moby-Dick",
            authors: ["Herman Melville"],
            summary: "The narrative of Captain Ahab’s obsessive quest to defeat the white whale.",
            languages: ["en"],
            bookshelves: ["Plays/Films/Dramas", "British literature"],
            downloadCount: 98765,
            coverURL: nil,
            isFavorite: true,
            isRead: true
        )
    ]
}
