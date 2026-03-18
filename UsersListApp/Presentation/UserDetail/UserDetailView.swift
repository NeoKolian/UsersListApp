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
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    HStack {
                        Spacer()
                        AsyncImage(url: user.pictureURL) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Image("userPlaceholder")
                        }
                        .frame(width: 120, height: 120)
                        .clipShape(.circle)
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                    
                    Text(user.fullName)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(user.email)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
//                .padding(.top, 16)
                
                InfoCard(title: "Personal Info") {
                    InfoRow(icon: "person", text: user.fullName)
                    InfoRow(icon: "figure.stand", text: user.gender.capitalized)
                    InfoRow(icon: "phone", text: user.phone)
                }
                
                InfoCard(title: "Location") {
                    InfoRow(icon: "mappin.and.ellipse", text: user.street)
                    InfoRow(icon: "building.2", text: user.city)
                    InfoRow(icon: "map", text: user.state)
                }
                
                InfoCard(title: "Registration") {
                    InfoRow(
                        icon: "calendar",
                        text: user.registeredDate.formatted(.dateTime.day().month().year())
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    NavigationStack {
        UserDetailView(user: .sample)
    }
}
