//
//  DefaultUserRepositoryTests.swift
//  UsersListAppTests
//
//  Created by Nikolay Pochekuev on 17.03.2026.
//

import XCTest
@testable import UsersListApp

@MainActor
final class DefaultUserRepositoryTests: XCTestCase {

    // MARK: - Deduplication
    func testFetchUsers_WithDuplicateEmails_ReturnsOnlyUniqueUsers() async throws {
        let dtos = [
            UserDTO.make(email: "john@test.com"),
            UserDTO.make(email: "john@test.com"),
            UserDTO.make(email: "nick@test.com")
        ]
        let sut = makeSUT(dtos: dtos)

        let result = try await sut.fetchUsers(page: 1)

        XCTAssertEqual(result.count, 2)
    }

    func testFetchUsers_WithAllDuplicates_ReturnsSingleUser() async throws {
        let dtos = [
            UserDTO.make(email: "same@test.com"),
            UserDTO.make(email: "same@test.com"),
            UserDTO.make(email: "same@test.com")
        ]
        let sut = makeSUT(dtos: dtos)

        let result = try await sut.fetchUsers(page: 1)

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.email, "same@test.com")
    }

    func testFetchUsers_AcrossPages_DeduplicatesByEmail() async throws {
        let sut = makeSUT(dtos: [
            UserDTO.make(email: "john@test.com"),
            UserDTO.make(email: "nick@test.com")
        ])

        _ = try await sut.fetchUsers(page: 1)
        let secondPage = try await sut.fetchUsers(page: 2)

        XCTAssertTrue(secondPage.isEmpty)
    }

    func testFetchUsers_NoDuplicates_ReturnsAllUsers() async throws {
        let dtos = [
            UserDTO.make(email: "a@test.com"),
            UserDTO.make(email: "b@test.com"),
            UserDTO.make(email: "c@test.com")
        ]
        let sut = makeSUT(dtos: dtos)

        let result = try await sut.fetchUsers(page: 1)

        XCTAssertEqual(result.count, 3)
    }

    // MARK: - Cached Users

    func testGetSavedUsers_ReturnsCachedUsersWithoutDuplicates() async throws {
        let dtos = [
            UserDTO.make(email: "john@test.com"),
            UserDTO.make(email: "john@test.com"),
            UserDTO.make(email: "nick@test.com")
        ]
        let sut = makeSUT(dtos: dtos)

        _ = try await sut.fetchUsers(page: 1)
        let saved = sut.getSavedUsers()

        XCTAssertEqual(saved.count, 2)
    }

    // MARK: - Helpers

    private func makeSUT(
        dtos: [UserDTO] = [],
        file: StaticString = #file,
        line: UInt = #line
    ) -> DefaultUserRepository {
        let client = MockUserNetworkClient(result: .success(dtos))
        return DefaultUserRepository(networkClient: client, storage: MockUserStorage())
    }
}
