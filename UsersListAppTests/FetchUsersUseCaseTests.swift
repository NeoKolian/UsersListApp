//
//  FetchUsersUseCaseTests.swift
//  UsersListAppTests
//
//  Created by Nikolay Pochekuev on 16.03.2026.
//

import XCTest
@testable import UsersListApp

@MainActor
final class FetchUsersUseCaseTests: XCTestCase {

    // MARK: - Error Propagation

    func testExecute_WhenRepositoryThrows_PropagatesError() async {
        let expectedError = NSError(domain: "test", code: 1)
        let sut = makeSUT(fetchResult: .failure(expectedError))

        do {
            _ = try await sut.execute(page: 1)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual((error as NSError).domain, "test")
            XCTAssertEqual((error as NSError).code, 1)
        }
    }

    // MARK: - Filtering Deleted Users

    func testExecute_FiltersDeletedUsers() async throws {
        let users = User.makeList(count: 3)
        let deletedEmails: Set<String> = [users[1].email]
        let sut = makeSUT(fetchResult: .success(users), deletedEmails: deletedEmails)

        let result = try await sut.execute(page: 1)

        XCTAssertEqual(result.count, 2)
        XCTAssertFalse(result.contains { $0.email == users[1].email })
    }

    func testExecute_WhenAllDeleted_ReturnsEmptyArray() async throws {
        let users = User.makeList(count: 2)
        let deletedEmails = Set(users.map(\.email))
        let sut = makeSUT(fetchResult: .success(users), deletedEmails: deletedEmails)

        let result = try await sut.execute(page: 1)

        XCTAssertTrue(result.isEmpty)
    }

    func testExecute_WhenNoneDeleted_ReturnsAllUsers() async throws {
        let users = User.makeList(count: 3)
        let sut = makeSUT(fetchResult: .success(users))

        let result = try await sut.execute(page: 1)

        XCTAssertEqual(result.count, 3)
    }

    // MARK: - Successful Fetch

    func testExecute_ReturnsUsersFromRepository() async throws {
        let users = User.makeList(count: 5)
        let sut = makeSUT(fetchResult: .success(users))

        let result = try await sut.execute(page: 1)

        XCTAssertEqual(result, users)
    }

    func testExecute_PassesPageToRepository() async throws {
        let repository = MockUserRepository()
        let sut = FetchUsersUseCase(repository: repository)

        _ = try await sut.execute(page: 42)

        XCTAssertEqual(repository.fetchedPage, 42)
    }

    // MARK: - Helpers

    private func makeSUT(
        fetchResult: Result<[User], Error> = .success([]),
        deletedEmails: Set<String> = [],
        file: StaticString = #file,
        line: UInt = #line
    ) -> FetchUsersUseCase {
        let repository = MockUserRepository(
            fetchResult: fetchResult,
            deletedEmails: deletedEmails
        )
        
        return FetchUsersUseCase(repository: repository)
    }

}
