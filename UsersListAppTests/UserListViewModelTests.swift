//
//  UserListViewModelTests.swift
//  UsersListAppTests
//
//  Created by Nikolay Pochekuev on 17.03.2026.
//

import XCTest
@testable import UsersListApp

@MainActor
final class UserListViewModelTests: XCTestCase {

    // MARK: - loadInitialUsers — Error

    func testLoadInitialUsers_WhenFetchFails_SetsErrorState() async {
        let sut = makeSUT(result: .failure(NSError(domain: "test", code: 1)))

        await sut.loadInitialUsers()

        guard case .error(let message) = sut.state else {
            return XCTFail("Expected .error state, got \(sut.state)")
        }
        XCTAssertFalse(message.isEmpty)
    }

    func testLoadInitialUsers_WhenFetchReturnsEmpty_SetsEmptyState() async {
        let sut = makeSUT(result: .success([]))

        await sut.loadInitialUsers()

        guard case .empty = sut.state else {
            return XCTFail("Expected .empty state, got \(sut.state)")
        }
    }

    // MARK: - loadInitialUsers — Success

    func testLoadInitialUsers_SetsLoadedStateWithUsers() async {
        let users = User.makeList(count: 3)
        let sut = makeSUT(result: .success(users))

        await sut.loadInitialUsers()

        guard case .loaded = sut.state else {
            return XCTFail("Expected .loaded state, got \(sut.state)")
        }
        XCTAssertEqual(sut.filteredUsers.count, 3)
    }

    func testLoadInitialUsers_WhenAlreadyLoaded_DoesNotReload() async {
        let users = User.makeList(count: 5)
        let repository = PagedMockRepository(pages: [1: users])
        let sut = makeSUT(repository: repository)

        await sut.loadInitialUsers()
        guard case .loaded = sut.state else {
            return XCTFail("Expected .loaded state")
        }
        XCTAssertEqual(sut.filteredUsers.count, 5)

        await sut.loadInitialUsers()
        guard case .loaded = sut.state else {
            return XCTFail("Expected .loaded state after second call")
        }
        XCTAssertEqual(sut.filteredUsers.count, 5, "Should keep existing data, not reload")
        XCTAssertEqual(repository.lastRequestedPage, 1, "Should not make a second request")
    }

    // MARK: - loadNextPageIfNeeded — Guards

    func testLoadNextPage_WhenNotLastUser_DoesNotLoad() async {
        let users = User.makeList(count: 3)
        let repository = PagedMockRepository(pages: [1: users, 2: User.makeList(count: 2)])
        let sut = makeSUT(repository: repository)

        await sut.loadInitialUsers()
        await sut.loadNextPageIfNeeded(lastDisplayedUser: users[0])

        guard case .loaded = sut.state else {
            return XCTFail("Expected .loaded state")
        }
        XCTAssertEqual(sut.filteredUsers.count, 3, "Should not load next page for non-last user")
    }

    func testLoadNextPage_WhenStateIsNotLoaded_DoesNotLoad() async {
        let sut = makeSUT(result: .success([]))
        let fakeUser = User.makeList(count: 1)[0]

        await sut.loadNextPageIfNeeded(lastDisplayedUser: fakeUser)

        guard case .empty = sut.state else {
            return XCTFail("Expected .empty state, got \(sut.state)")
        }
    }

    // MARK: - loadNextPageIfNeeded — Success

    func testLoadNextPage_WhenLastUser_AppendsNewUsers() async {
        let page1 = User.makeList(count: 3)
        let page2 = User.makeList(count: 2)
        let repository = PagedMockRepository(pages: [1: page1, 2: page2])
        let sut = makeSUT(repository: repository)

        await sut.loadInitialUsers()
        await sut.loadNextPageIfNeeded(lastDisplayedUser: page1.last!)

        guard case .loaded = sut.state else {
            return XCTFail("Expected .loaded state")
        }
        XCTAssertEqual(sut.filteredUsers.count, 5)
    }

    func testLoadNextPage_IncrementsByPage() async {
        let page1 = User.makeList(count: 2)
        let page2 = User.makeList(count: 2)
        let page3 = User.makeList(count: 1)
        let repository = PagedMockRepository(pages: [1: page1, 2: page2, 3: page3])
        let sut = makeSUT(repository: repository)

        await sut.loadInitialUsers()
        await sut.loadNextPageIfNeeded(lastDisplayedUser: page1.last!)

        guard case .loaded = sut.state else {
            return XCTFail("Expected .loaded state")
        }
        XCTAssertEqual(sut.filteredUsers.count, 4)

        await sut.loadNextPageIfNeeded(lastDisplayedUser: page2.last!)

        guard case .loaded = sut.state else {
            return XCTFail("Expected .loaded state")
        }
        XCTAssertEqual(sut.filteredUsers.count, 5)
        XCTAssertEqual(repository.lastRequestedPage, 3)
    }

    // MARK: - loadNextPageIfNeeded — Error

    func testLoadNextPage_WhenFetchFails_RevertsPage() async {
        let page1 = User.makeList(count: 3)
        let repository = PagedMockRepository(
            pages: [1: page1],
            errorOnPage: 2
        )
        let sut = makeSUT(repository: repository)

        await sut.loadInitialUsers()
        await sut.loadNextPageIfNeeded(lastDisplayedUser: page1.last!)

        guard case .loaded = sut.state else {
            return XCTFail("Expected .loaded state, got \(sut.state)")
        }
        XCTAssertEqual(sut.filteredUsers.count, 3, "Should keep existing users on error")
    }

    // MARK: - delete

    func testDeleteUser_RemovesUserFromList() async {
        let users = User.makeList(count: 3)
        let repository = PagedMockRepository(pages: [1: users])
        let sut = makeSUT(repository: repository)

        await sut.loadInitialUsers()
        sut.deleteUser(users[1])

        guard case .loaded = sut.state else {
            return XCTFail("Expected .loaded state")
        }
        XCTAssertEqual(sut.filteredUsers.count, 2)
        XCTAssertFalse(sut.filteredUsers.contains { $0.id == users[1].id })
    }

    func testDeleteUser_DelegatesToRepository() async {
        let users = User.makeList(count: 2)
        let repository = PagedMockRepository(pages: [1: users])
        let sut = makeSUT(repository: repository)

        await sut.loadInitialUsers()
        sut.deleteUser(users[0])

        XCTAssertTrue(repository.deletedIDs.contains(users[0].id))
    }

    func testDeleteUser_WhenAllDeleted_SetsEmptyState() async {
        let users = User.makeList(count: 1)
        let repository = PagedMockRepository(pages: [1: users])
        let sut = makeSUT(repository: repository)

        await sut.loadInitialUsers()
        sut.deleteUser(users[0])

        guard case .empty = sut.state else {
            return XCTFail("Expected .empty state, got \(sut.state)")
        }
    }

    // MARK: - search

    func testFilteredUsers_WhenSearchEmpty_ReturnsAllUsers() async {
        let users = User.makeList(count: 5)
        let sut = makeSUT(result: .success(users))

        await sut.loadInitialUsers()

        XCTAssertEqual(sut.filteredUsers.count, 5)
    }

    func testFilteredUsers_FiltersByFirstName() async {
        let users = User.makeList(count: 5)
        let sut = makeSUT(result: .success(users))

        await sut.loadInitialUsers()
        sut.searchText = users[0].firstName

        XCTAssertTrue(sut.filteredUsers.allSatisfy {
            $0.firstName.localizedStandardContains(users[0].firstName)
        })
    }

    func testFilteredUsers_FiltersByEmail() async {
        let users = User.makeList(count: 5)
        let sut = makeSUT(result: .success(users))

        await sut.loadInitialUsers()
        sut.searchText = users[2].email

        XCTAssertEqual(sut.filteredUsers.count, 1)
        XCTAssertEqual(sut.filteredUsers.first?.email, users[2].email)
    }

    func testFilteredUsers_WhenNoMatch_ReturnsEmpty() async {
        let users = User.makeList(count: 3)
        let sut = makeSUT(result: .success(users))

        await sut.loadInitialUsers()
        sut.searchText = "zzzznonexistent"

        XCTAssertTrue(sut.filteredUsers.isEmpty)
    }

    func testFilteredUsers_WhenStateNotLoaded_ReturnsEmpty() async {
        let sut = makeSUT(result: .success([]))
        sut.searchText = "test"

        XCTAssertTrue(sut.filteredUsers.isEmpty)
    }

    // MARK: - Helpers

    private func makeSUT(
        result: Result<[User], Error> = .success([]),
        file: StaticString = #file,
        line: UInt = #line
    ) -> UserListViewModel {
        let repository = MockUserRepository(fetchResult: result)
        let useCase = FetchUsersUseCase(repository: repository)
        return UserListViewModel(fetchUseCase: useCase, repository: repository)
    }

    private func makeSUT(
        repository: PagedMockRepository,
        file: StaticString = #file,
        line: UInt = #line
    ) -> UserListViewModel {
        let useCase = FetchUsersUseCase(repository: repository)
        return UserListViewModel(fetchUseCase: useCase, repository: repository)
    }
}

// MARK: - PagedMockRepository

private final class PagedMockRepository: UserRepositoryProtocol {
    private let pages: [Int: [User]]
    private let errorOnPage: Int?
    private(set) var lastRequestedPage: Int?
    private(set) var deletedIDs: Set<String> = []

    init(pages: [Int: [User]], errorOnPage: Int? = nil) {
        self.pages = pages
        self.errorOnPage = errorOnPage
    }

    func fetchUsers(page: Int) async throws -> [User] {
        lastRequestedPage = page
        if page == errorOnPage {
            throw NSError(domain: "test", code: 1)
        }
        return pages[page] ?? []
    }

    func getSavedUsers() -> [User] { [] }

    func deleteUser(id: String) {
        deletedIDs.insert(id)
    }

    func isDeleted(id: String) -> Bool {
        deletedIDs.contains(id)
    }
}
