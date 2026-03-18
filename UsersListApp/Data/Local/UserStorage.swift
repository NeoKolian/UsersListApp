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
    func loadDeletedEmails() -> Set<String>
    func saveDeletedEmails(_ emails: Set<String>)
}

final class UserDefaultsStorage: UserStorageProtocol {

    private enum Keys {
        static let cachedUsers = "cachedUsers"
        static let deletedEmails = "deletedEmails"
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

    func loadDeletedEmails() -> Set<String> {
        let array = defaults.stringArray(forKey: Keys.deletedEmails) ?? []
        return Set(array)
    }

    func saveDeletedEmails(_ emails: Set<String>) {
        defaults.set(Array(emails), forKey: Keys.deletedEmails)
    }
}
