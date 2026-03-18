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
    func deleteUser(email: String)
    func isDeleted(email: String) -> Bool
}

final class DefaultUserRepository: UserRepositoryProtocol {

    private let networkClient: UserNetworkClientProtocol
    private let storage: UserStorageProtocol
    private var cachedUsers: [User]
    private var knownEmails: Set<String>
    private var deletedEmails: Set<String>

    init(
        networkClient: UserNetworkClientProtocol = UserNetworkClient(),
        storage: UserStorageProtocol = UserDefaultsStorage()
    ) {
        self.networkClient = networkClient
        self.storage = storage
        
        self.cachedUsers = storage.loadUsers()
        self.knownEmails = Set(cachedUsers.map(\.email))
        self.deletedEmails = storage.loadDeletedEmails()
    }
    
    func fetchUsers(page: Int) async throws -> [User] {
        if page == 1 {
            cachedUsers = []
            knownEmails = []
        }

        let dtos = try await networkClient.fetchUsers(page: page, count: 20)
        let users = dtos.compactMap(UserMapper.map)
        
        let newUsers = users.filter { knownEmails.insert($0.email).inserted }
        cachedUsers.append(contentsOf: newUsers)
        storage.saveUsers(cachedUsers)
        return newUsers
    }
    
    func getSavedUsers() -> [User] {
        cachedUsers.filter { !deletedEmails.contains($0.email) }
    }

    func deleteUser(email: String) {
        deletedEmails.insert(email)
        storage.saveDeletedEmails(deletedEmails)

        cachedUsers.removeAll { $0.email == email }
        knownEmails.remove(email)
        storage.saveUsers(cachedUsers)
    }
    
    func isDeleted(email: String) -> Bool {
        deletedEmails.contains(email)
    }
}
