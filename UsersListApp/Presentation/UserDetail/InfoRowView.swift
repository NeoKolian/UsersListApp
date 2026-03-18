//
//  InfoRowView.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 18.03.2026.
//

import SwiftUI

struct InfoRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 20)
                .foregroundStyle(.secondary)
            
            Text(text)
                .font(.subheadline)
            
            Spacer()
        }
    }
}
