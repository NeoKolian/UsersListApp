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

    var state: ViewState = .empty

    private let fetch: FetchUsersUseCase
    private var currentPage = 1

    init(fetchUseCase: FetchUsersUseCase) {
        self.fetch = fetchUseCase
    }

    func loadInitialUsers() async {
        state = .loading
        currentPage = 1
        await fetchUsers(page: currentPage)
    }

    private func fetchUsers(page: Int) async {
        do {
            let users = try await fetch.execute(page: page)
            state = .loaded(users)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
