//
//  BooksPageResponse.swift
//  GutenBooks
//
//  Created by Viktor Zavhorodnii on 04/02/2026.
//

import Foundation

struct BooksPageResponse: Decodable {
    let count: Int
    let next: String?
    let results: [BookResponse]

    var nextURL: URL? {
        guard let next else { return nil }
        return URL(string: next)
    }
}
