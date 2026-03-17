//
//  MockUserNetworkClient.swift
//  UsersListAppTests
//
//  Created by Nikolay Pochekuev on 17.03.2026.
//

import Foundation
@testable import UsersListApp

final class MockUserNetworkClient: UserNetworkClientProtocol {
    private let result: Result<[UserDTO], Error>

    init(result: Result<[UserDTO], Error> = .success([])) {
        self.result = result
    }

    func fetchUsers(page: Int, count: Int) async throws -> [UserDTO] {
        try result.get()
    }
}
