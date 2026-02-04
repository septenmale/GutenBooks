//
//  NetworkError.swift
//  GutenBooks
//
//  Created by Viktor Zavhorodnii on 04/02/2026.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpStatus(Int)
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid response"
        case .httpStatus(let code): return "HTTP error: \(code)"
        case .decodingFailed: return "Failed to decode server response"
        }
    }
}
