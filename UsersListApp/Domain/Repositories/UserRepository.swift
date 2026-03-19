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
    private let pageSize: Int

    private var cachedUsers: [User]
    private var knownEmails: Set<String>
    private var deletedEmails: Set<String>

    init(
        networkClient: UserNetworkClientProtocol = UserNetworkClient(),
        storage: UserStorageProtocol = UserDefaultsStorage(),
        pageSize: Int = 20
    ) {
        self.networkClient = networkClient
        self.storage = storage
        self.pageSize = pageSize

        self.cachedUsers = storage.loadUsers()
        self.knownEmails = Set(cachedUsers.map(\.email))
        self.deletedEmails = storage.loadDeletedEmails()
    }

    func fetchUsers(page: Int) async throws -> [User] {
        let storedPage = loadPageFromCache(page)
        if !storedPage.isEmpty {
            return storedPage
        }
        return try await fetchUsersFromAPI(page: page)
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

    // MARK: - Private methods

    private func loadPageFromCache(_ page: Int) -> [User] {
        let startIndex = (page - 1) * pageSize
        guard startIndex < cachedUsers.count else { return [] }
        let endIndex = min(startIndex + pageSize, cachedUsers.count)
        return Array(cachedUsers[startIndex..<endIndex])
    }

    private func fetchUsersFromAPI(page: Int) async throws -> [User] {
        if page == 1 {
            cachedUsers = []
            knownEmails = []
        }

        let dtos = try await networkClient.fetchUsers(page: page, count: pageSize)
        let users = dtos.compactMap(UserMapper.map)

        let newUsers = users.filter { knownEmails.insert($0.email).inserted }
        cachedUsers.append(contentsOf: newUsers)
        storage.saveUsers(cachedUsers)
        return newUsers
    }
}
