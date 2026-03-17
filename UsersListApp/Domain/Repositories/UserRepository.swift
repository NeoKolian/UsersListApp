//
//  UserRepository.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 16.03.2026.
//

import Foundation

protocol UserRepositoryProtocol {
    func fetchUsers(page: Int) async throws -> [User]
    func getSavedUsers() -> [User]
    func deleteUser(id: String)
    func isDeleted(id: String) -> Bool
}

final class DefaultUserRepository: UserRepositoryProtocol {

    private let networkClient: UserNetworkClient
    private var cachedUsers: [User] = []
    private var deletedIDs: Set<String> = []

    init(networkClient: UserNetworkClient = UserNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchUsers(page: Int) async throws -> [User] {
        let dtos = try await networkClient.fetchUsers(page: page)
        let users = dtos.compactMap(UserMapper.map)
        cachedUsers.append(contentsOf: users)
        return users
    }
    
    func getSavedUsers() -> [User] {
        cachedUsers.filter { !deletedIDs.contains($0.id) }
    }

    func deleteUser(id: String) {
        deletedIDs.insert(id)
    }
    
    func isDeleted(id: String) -> Bool {
        deletedIDs.contains(id)
    }
}
