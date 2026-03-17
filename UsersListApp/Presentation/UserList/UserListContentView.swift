//
//  UserListContentView.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 16.03.2026.
//

import SwiftUI

struct UserListContentView: View {
    let state: UserListViewModel.ViewState
    let filteredUsers: [User]
    let isLoadingMore: Bool
    let onUserAppear: (User) -> Void
    let onDelete: (User) -> Void

    var body: some View {
        switch state {
        case .empty:
            ContentUnavailableView(
                "No Users",
                systemImage: "person.slash",
                description: Text("Pull to refresh or try again later.")
            )
        case .loading:
            ProgressView("Loading...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .loaded:
            if filteredUsers.isEmpty {
                ContentUnavailableView.search
            } else {
                List {
                    ForEach(filteredUsers) { user in
                        NavigationLink(value: user) {
                            UserListRowView(user: user)
                        }
                        .onAppear { onUserAppear(user) }
                    }
                    .onDelete { offsets in
                        for index in offsets {
                            onDelete(filteredUsers[index])
                        }
                    }
                    if isLoadingMore {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
            }
        case .error(let message):
            ContentUnavailableView(
                "Something went wrong",
                systemImage: "exclamationmark.triangle",
                description: Text(message)
            )
        }
    }
}
