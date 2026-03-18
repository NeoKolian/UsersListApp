//
//  InfoCardView.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 18.03.2026.
//

import SwiftUI

struct InfoCard<Content: View>: View {
   
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            
            VStack(spacing: 12) {
                content
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }
}
