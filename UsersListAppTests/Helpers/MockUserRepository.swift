//
//  MockUserRepository.swift
//  UsersListAppTests
//
//  Created by Nikolay Pochekuev on 16.03.2026.
//

import Foundation
@testable import UsersListApp

final class MockUserRepository: UserRepositoryProtocol {
    private let fetchResult: Result<[User], Error>
    private(set) var deletedIDs: Set<String>
    private(set) var fetchedPage: Int?

    init(
        fetchResult: Result<[User], Error> = .success([]),
        deletedIDs: Set<String> = []
    ) {
        self.fetchResult = fetchResult
        self.deletedIDs = deletedIDs
    }

    func fetchUsers(page: Int) async throws -> [User] {
        fetchedPage = page
        return try fetchResult.get()
    }

    func getSavedUsers() -> [User] { [] }

    func deleteUser(id: String) {
        deletedIDs.insert(id)
    }

    func isDeleted(id: String) -> Bool {
        deletedIDs.contains(id)
    }
}
