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
    private let storage: UserStorageProtocol
    private var cachedUsers: [User]
    private var knownEmails: Set<String>
    private var deletedIDs: Set<String>

    init(
        networkClient: UserNetworkClientProtocol = UserNetworkClient(),
        storage: UserStorageProtocol = UserDefaultsStorage()
    ) {
        self.networkClient = networkClient
        self.storage = storage
        
        self.cachedUsers = storage.loadUsers()
        self.knownEmails = Set(cachedUsers.map(\.email))
        self.deletedIDs = storage.loadDeletedIDs()
    }
    
    func fetchUsers(page: Int) async throws -> [User] {
        let dtos = try await networkClient.fetchUsers(page: page, count: 20)
        let users = dtos.compactMap(UserMapper.map)
        
        let newUsers = users.filter { knownEmails.insert($0.email).inserted }
        cachedUsers.append(contentsOf: newUsers)
        storage.saveUsers(cachedUsers)
        return newUsers
    }
    
    func getSavedUsers() -> [User] {
        cachedUsers.filter { !deletedIDs.contains($0.id) }
    }

    func deleteUser(id: String) {
        deletedIDs.insert(id)
        storage.saveDeletedIDs(deletedIDs)
    }
    
    func isDeleted(id: String) -> Bool {
        deletedIDs.contains(id)
    }
}
