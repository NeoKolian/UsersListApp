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
                filteredUsers: viewModel.filteredUsers,
                isLoadingMore: viewModel.isLoadingMore,
                onUserAppear: { user in
                    Task { await viewModel.loadNextPageIfNeeded(lastDisplayedUser: user) }
                },
                onDelete: { user in
                    viewModel.deleteUser(user)
                },
                onRetry: {
                    Task { await viewModel.retry() }
                }
            )
            .searchable(text: $viewModel.searchText, prompt: "Search by name or email")
            .navigationTitle("Random Users")
            .navigationDestination(for: User.self) { user in
                UserDetailView(user: user)
            }
            .refreshable {
                await viewModel.refreshUsers()
            }
            .task { await viewModel.loadInitialUsers() }
        }
    }
}

// MARK: - Previews

private final class LoadedPreviewRepository: UserRepositoryProtocol {
    func fetchUsers(page: Int) async throws -> [User] { User.sampleList }
    func getSavedUsers() -> [User] { User.sampleList }
    func deleteUser(email: String) {}
    func isDeleted(email: String) -> Bool { false }
}

#Preview("Loaded") {
    let repository = LoadedPreviewRepository()
    UserListView(
        viewModel: UserListViewModel(
            fetchUseCase: FetchUsersUseCase(repository: repository),
            repository: repository
        )
    )
}
