//
//  RandomUserService.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 16.03.2026.
//

import Foundation

final class UserNetworkClient {

    private let session: URLSession
    private let baseURL = URL(string: "https://randomuser.me")!
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchUsers(page: Int, count: Int = 20) async throws -> [UserDTO] {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            .init(name: "results", value: "\(count)"),
            .init(name: "page",    value: "\(page)"),
            .init(name: "seed",    value: "randomuser")
        ]
        let (data, _) = try await session.data(from: components.url!)
        return try JSONDecoder().decode(UserResponseDTO.self, from: data).results
    }
}
