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

    private let networkClient: UserNetworkClientProtocol
    private var cachedUsers: [User] = []
    private var knownEmails: Set<String> = []
    private var deletedIDs: Set<String> = []

    init(networkClient: UserNetworkClientProtocol = UserNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchUsers(page: Int) async throws -> [User] {
        let dtos = try await networkClient.fetchUsers(page: page, count: 20)
        let users = dtos.compactMap(UserMapper.map)
        
        let newUsers = users.filter { knownEmails.insert($0.email).inserted }
        cachedUsers.append(contentsOf: newUsers)
        return newUsers
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
