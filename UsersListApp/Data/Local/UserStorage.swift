//
//  UserStorage.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 18.03.2026.
//

import Foundation

protocol UserStorageProtocol {
    func loadUsers() -> [User]
    func saveUsers(_ users: [User])
    func loadDeletedIDs() -> Set<String>
    func saveDeletedIDs(_ ids: Set<String>)
}

final class UserDefaultsStorage: UserStorageProtocol {

    private enum Keys {
        static let cachedUsers = "cachedUsers"
        static let deletedIDs = "deletedIDs"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func loadUsers() -> [User] {
        guard let data = defaults.data(forKey: Keys.cachedUsers) else { return [] }
        return (try? JSONDecoder().decode([User].self, from: data)) ?? []
    }

    func saveUsers(_ users: [User]) {
        let data = try? JSONEncoder().encode(users)
        defaults.set(data, forKey: Keys.cachedUsers)
    }

    func loadDeletedIDs() -> Set<String> {
        let array = defaults.stringArray(forKey: Keys.deletedIDs) ?? []
        return Set(array)
    }

    func saveDeletedIDs(_ ids: Set<String>) {
        defaults.set(Array(ids), forKey: Keys.deletedIDs)
    }
}
