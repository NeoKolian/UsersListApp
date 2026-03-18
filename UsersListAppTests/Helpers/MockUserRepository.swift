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
    private(set) var deletedEmails: Set<String>
    private(set) var fetchedPage: Int?

    init(
        fetchResult: Result<[User], Error> = .success([]),
        deletedEmails: Set<String> = []
    ) {
        self.fetchResult = fetchResult
        self.deletedEmails = deletedEmails
    }

    func fetchUsers(page: Int) async throws -> [User] {
        fetchedPage = page
        return try fetchResult.get()
    }

    func getSavedUsers() -> [User] { [] }

    func deleteUser(email: String) {
        deletedEmails.insert(email)
    }

    func isDeleted(email: String) -> Bool {
        deletedEmails.contains(email)
    }
}
