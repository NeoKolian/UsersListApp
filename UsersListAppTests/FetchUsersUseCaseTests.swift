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
        let deletedIDs: Set<String> = [users[1].id]
        let sut = makeSUT(fetchResult: .success(users), deletedIDs: deletedIDs)

        let result = try await sut.execute(page: 1)

        XCTAssertEqual(result.count, 2)
        XCTAssertFalse(result.contains { $0.id == users[1].id })
    }

    func testExecute_WhenAllDeleted_ReturnsEmptyArray() async throws {
        let users = User.makeList(count: 2)
        let deletedIDs = Set(users.map(\.id))
        let sut = makeSUT(fetchResult: .success(users), deletedIDs: deletedIDs)

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
        deletedIDs: Set<String> = [],
        file: StaticString = #file,
        line: UInt = #line
    ) -> FetchUsersUseCase {
        let repository = MockUserRepository(
            fetchResult: fetchResult,
            deletedIDs: deletedIDs
        )
        
        return FetchUsersUseCase(repository: repository)
    }

    private func makeUsers(count: Int) -> [User] {
        (0..<count).map { i in
            User(
                id: UUID().uuidString,
                firstName: "First\(i)",
                lastName: "Last\(i)",
                email: "user\(i)@test.com",
                phone: "000-\(i)",
                pictureURL: URL(string: "https://example.com/\(i).jpg") ?? URL(fileURLWithPath: ""),
                gender: "male",
                street: "\(i) Test St",
                city: "City",
                state: "State",
                registeredDate: .now
            )
        }
    }

    // MARK: - Mock

    private final class MockUserRepository: UserRepositoryProtocol {
        private let fetchResult: Result<[User], Error>
        private let deletedIDs: Set<String>
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
        func deleteUser(id: String) {}

        func isDeleted(id: String) -> Bool {
            deletedIDs.contains(id)
        }
    }
}
