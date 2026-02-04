//
//  BookResponse.swift
//  GutenBooks
//
//  Created by Viktor Zavhorodnii on 03/02/2026.
//

struct BookResponse: Decodable {
    let id: Int
    let title: String
    let authors: [AuthorResponse]
    let summaries: [String]
    let languages: [String]
    let bookshelves: [String]
    let downloadCount: Int
    let formats: [String: String]
}

struct AuthorResponse: Decodable {
    let name: String
}
