//
//  UsersListAppApp.swift
//  UsersListApp
//
//  Created by Nikolay Pochekuev on 16.03.2026.
//

import SwiftUI
import CoreData

@main
struct UsersListAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
