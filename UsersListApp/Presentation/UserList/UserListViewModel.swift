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
        case loaded([User])
        case error(String)
    }

    private(set) var state: ViewState = .empty
    private(set) var isLoadingMore = false

    private let fetch: FetchUsersUseCase
    private var currentPage = 1
    private var allUsers: [User] = []

    init(fetchUseCase: FetchUsersUseCase) {
        self.fetch = fetchUseCase
    }

    func loadInitialUsers() async {
        guard case .empty = state else { return }
        state = .loading
        currentPage = 1
        allUsers = []
        do {
            let users = try await fetch.execute(page: currentPage)
            allUsers = users
            state = users.isEmpty ? .empty : .loaded(users)
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func loadNextPageIfNeeded(lastDisplayedUser user: User) async {
        guard case .loaded = state,
              !isLoadingMore,
              user.id == allUsers.last?.id else { return }

        isLoadingMore = true
        defer { isLoadingMore = false }

        currentPage += 1
        do {
            let newUsers = try await fetch.execute(page: currentPage)
            allUsers.append(contentsOf: newUsers)
            state = .loaded(allUsers)
        } catch {
            currentPage -= 1
        }
    }
}
