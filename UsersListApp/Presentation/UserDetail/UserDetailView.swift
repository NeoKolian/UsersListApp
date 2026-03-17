//
//  UserDetailView.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 17.03.2026.
//

import SwiftUI

struct UserDetailView: View {
    
    let user: User

    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    AsyncImage(url: user.pictureURL)
                    .frame(width: 120, height: 120)
                    .clipShape(.circle)
                    .scaledToFill()
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }

            Section("Personal Info") {
                Label(user.fullName, systemImage: "person")
                Label(user.gender.capitalized, systemImage: "figure.stand")
 
                Label(user.email, systemImage: "envelope")
                Label(user.phone, systemImage: "phone")
            }

            Section("Location") {
                Label(user.street, systemImage: "mappin.and.ellipse")
                Label(user.city, systemImage: "building.2")
                Label(user.state, systemImage: "map")
                Label {
                    Text(user.registeredDate, format: .dateTime.day().month().year())
                } icon: {
                    Image(systemName: "calendar")
                }
            }
        }
        .navigationTitle(user.fullName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        UserDetailView(user: .sample)
    }
}
