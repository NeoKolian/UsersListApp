//
//  UserListContentView.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 16.03.2026.
//

import SwiftUI

struct UserListContentView: View {
    let isLoading: Bool
    let users: [User]
    let errorMessage: String?

    var body: some View {
        if isLoading && users.isEmpty {
            ProgressView("Loading...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            UserListBodyView(users: users, errorMessage: errorMessage)
        }
    }
}
