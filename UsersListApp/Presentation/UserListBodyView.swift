//
//  UserListBodyView.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 16.03.2026.
//

import SwiftUI

struct UserListBodyView: View {
    let users: [User]
    let errorMessage: String?

    var body: some View {
        List(users) { user in
            UserListRowView(user: user)
        }
        .listStyle(.plain)
        .overlay {
            if let error = errorMessage {
                ContentUnavailableView(
                    "Something went wrong",
                    systemImage: "exclamationmark.triangle",
                    description: Text(error)
                )
            }
        }
    }
}
