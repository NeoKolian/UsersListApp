//
//  FetchUsersUseCase.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 16.03.2026.
//

import Foundation

final class FetchUsersUseCase {
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func execute(page: Int) async throws -> [User] {
        let fetched = try await repository.fetchUsers(page: page)
        return fetched.filter { !repository.isDeleted(id: $0.id) }
    }
}
