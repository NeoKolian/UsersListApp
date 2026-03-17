//
//  UserListView.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 16.03.2026.
//

import SwiftUI

struct UserListView: View {
    @State var viewModel: UserListViewModel

    var body: some View {
        NavigationStack {
            UserListContentView(
                state: viewModel.state,
                isLoadingMore: viewModel.isLoadingMore,
                onUserAppear: { user in
                    Task { await viewModel.loadNextPageIfNeeded(lastDisplayedUser: user) }
                }
            )
            .navigationTitle("Random Users")
            .task { await viewModel.loadInitialUsers() }
        }
    }
}

// MARK: - Previews

private final class LoadedPreviewRepository: UserRepositoryProtocol {
    func fetchUsers(page: Int) async throws -> [User] { User.sampleList }
    func getSavedUsers() -> [User] { User.sampleList }
    func deleteUser(id: String) {}
    func isDeleted(id: String) -> Bool { false }
}

private final class LoadingPreviewRepository: UserRepositoryProtocol {
    func fetchUsers(page: Int) async throws -> [User] {
        try await Task.sleep(for: .seconds(2))
        return User.sampleList
    }
    func getSavedUsers() -> [User] { [] }
    func deleteUser(id: String) {}
    func isDeleted(id: String) -> Bool { false }
}

#Preview("Loaded") {
    UserListView(
        viewModel: UserListViewModel(
            fetchUseCase: FetchUsersUseCase(repository: LoadedPreviewRepository())
        )
    )
}
