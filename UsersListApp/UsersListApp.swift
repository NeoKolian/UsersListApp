//
//  UsersListAppApp.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 16.03.2026.
//

import SwiftUI

@main
struct UsersListApp: App {
    
//    @State private var repository = DefaultUserRepository()
    
    // in case if API randomUsers dosent work
    @State private var repository = DefaultUserRepository(
        networkClient: StubUserNetworkClient()
    )

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
