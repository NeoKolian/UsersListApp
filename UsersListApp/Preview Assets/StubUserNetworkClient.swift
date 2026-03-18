//
//  StubsUserNetworkClient.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 18.03.2026.
//

import Foundation

/// Use when API randomuser.me is not working.
final class StubUserNetworkClient: UserNetworkClientProtocol {

    private let users: [UserDTO]

    init(bundle: Bundle = .main) {
        guard let url = bundle.url(forResource: "ListSampleData", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let response = try? JSONDecoder().decode(UserResponseDTO.self, from: data)
        else {
            users = []
            return
        }

        users = response.results
    }

    func fetchUsers(page: Int, count: Int) async throws -> [UserDTO] {
        let startIndex = (page - 1) * count
        guard startIndex < users.count else { return [] }
        let endIndex = min(startIndex + count, users.count)
        return Array(users[startIndex..<endIndex])
    }
}
