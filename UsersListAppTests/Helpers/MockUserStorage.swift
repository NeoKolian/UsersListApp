//
//  MockUserStorage.swift
//  UsersListAppTests
//
//  Created by Nikolay Pochekuev on 18.03.2026.
//

import Foundation
@testable import UsersListApp

final class MockUserStorage: UserStorageProtocol {
    private var users: [User] = []
    private var deletedIDs: Set<String> = []

    func loadUsers() -> [User] { users }

    func saveUsers(_ users: [User]) {
        self.users = users
    }

    func loadDeletedIDs() -> Set<String> { deletedIDs }

    func saveDeletedIDs(_ ids: Set<String>) {
        self.deletedIDs = ids
    }
}
