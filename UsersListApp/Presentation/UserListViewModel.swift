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
    var users: [User] = []
    var isLoading = false
    var errorMessage: String?

    private let fetch: FetchUsersUseCase
    private var currentPage = 1

    init(fetchUseCase: FetchUsersUseCase) {
        self.fetch = fetchUseCase
    }

    func loadInitialUsers() async {
        currentPage = 1
        await fetchUsers(page: currentPage)
    }

    private func fetchUsers(page: Int) async {
        isLoading = true
        defer { isLoading = false }
        do {
            users = try await fetch.execute(page: page)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
