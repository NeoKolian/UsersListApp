//
//  NetworkError.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 16.03.2026.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidBaseURL
    case invalidURLComponents
    case invalidResponse
    case statusCode(Int)
    case decoding(Error)
    case network(Error)

    var errorDescription: String? {
        switch self {
        case .invalidBaseURL:
            "The provided base URL is invalid."
        case .invalidURLComponents:
            "Failed to construct a valid URL from components."
        case .invalidResponse:
            "The server returned an invalid response."
        case .statusCode(let code):
            "Unexpected status code: \(code)."
        case .decoding(let error):
            "Failed to decode response: \(error.localizedDescription)"
        case .network(let error):
            "Network error: \(error.localizedDescription)"
        }
    }
}
