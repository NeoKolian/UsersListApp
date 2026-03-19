//
//  UsersListAppApp.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 16.03.2026.
//

import SwiftUI

@main
struct UsersListApp: App {
    
    @State private var repository = DefaultUserRepository()

    var body: some Scene {
        WindowGroup {
            UserListView(
                viewModel: UserListViewModel(
                    fetchUseCase: FetchUsersUseCase(repository: repository),
                    repository: repository
                )
            )
        }
    }
}
