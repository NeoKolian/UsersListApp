//
//  RandomUserService.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 16.03.2026.
//

import Foundation

final class UserNetworkClient {

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

    private let session: URLSession
    private let baseURL = URL(string: "https://randomuser.me")
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchUsers(page: Int, count: Int = 20) async throws -> [UserDTO] {
        guard let baseURL else { throw NetworkError.invalidBaseURL }

        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            .init(name: "results", value: "\(count)"),
            .init(name: "page",    value: "\(page)"),
            .init(name: "seed",    value: "randomuser")
        ]

        guard let url = components?.url else { throw NetworkError.invalidURLComponents }

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw NetworkError.network(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(UserResponseDTO.self, from: data).results
        } catch {
            throw NetworkError.decoding(error)
        }
    }
}
