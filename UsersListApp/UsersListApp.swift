//
//  UsersListAppApp.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 16.03.2026.
//

import SwiftUI
import CoreData

@main
struct UsersListApp: App {
    var body: some Scene {
        WindowGroup {
            let repository = DefaultUserRepository()
            
            UserListView(
                viewModel: UserListViewModel(
                    fetchUseCase: FetchUsersUseCase(repository: repository),
                    repository: repository
                )
            )
        }
    }
}
