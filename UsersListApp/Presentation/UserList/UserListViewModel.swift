//
//  UserListViewModel.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 16.03.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class UserListViewModel {

    enum ViewState {
        case empty
        case loading
        case loaded
        case error(String)
    }

    private(set) var state: ViewState = .empty
    private(set) var isLoadingMore = false
    var searchText = ""

    private let fetch: FetchUsersUseCase
    private let repository: UserRepositoryProtocol
    private var currentPage = 1
    private var allUsers: [User] = []

    var filteredUsers: [User] {
        guard case .loaded = state else { return [] }
        guard !searchText.isEmpty else { return allUsers }
        return allUsers.filter {
            $0.firstName.localizedStandardContains(searchText)
            || $0.lastName.localizedStandardContains(searchText)
            || $0.email.localizedStandardContains(searchText)
        }
    }

    init(fetchUseCase: FetchUsersUseCase, repository: UserRepositoryProtocol) {
        self.fetch = fetchUseCase
        self.repository = repository
    }

    func retry() async {
        state = .empty
        await loadInitialUsers()
    }

    func loadInitialUsers() async {
        guard case .empty = state else { return }
        state = .loading
        currentPage = 1
        allUsers = []
        do {
            let users = try await fetch.execute(page: currentPage)
            allUsers = users
            state = users.isEmpty ? .empty : .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func loadNextPageIfNeeded(lastDisplayedUser user: User) async {
        guard case .loaded = state,
              !isLoadingMore,
              user.id == filteredUsers.last?.id else { return }

        isLoadingMore = true
        defer { isLoadingMore = false }

        currentPage += 1
        do {
            let newUsers = try await fetch.execute(page: currentPage)
            allUsers.append(contentsOf: newUsers)
            state = .loaded
        } catch {
            currentPage -= 1
        }
    }

    func deleteUser(_ user: User) {
        repository.deleteUser(id: user.id)
        allUsers.removeAll { $0.id == user.id }
        state = allUsers.isEmpty ? .empty : .loaded
    }
}
