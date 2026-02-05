//
//  GutenBooksServiceProtocol.swift
//  GutenBooks
//
//  Created by Viktor Zavhorodnii on 04/02/2026.
//

import Foundation

protocol GutenBooksServiceProtocol {
    func fetchBooksPage(nextURL: URL?) async throws -> BooksPageResponse
}

final class GutenBooksService: GutenBooksServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }
    
    func fetchBooksPage(nextURL: URL?) async throws -> BooksPageResponse {
        let url = nextURL ?? URL(string: "https://gutendex.com/books")
        guard let url else { throw NetworkError.invalidURL }
        
        let (data, response) = try await session.data(from: url)
        
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        guard (200...299).contains(http.statusCode) else {
            throw NetworkError.httpStatus(http.statusCode)
        }
        
        do {
            return try decoder.decode(BooksPageResponse.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
