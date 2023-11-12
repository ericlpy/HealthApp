//
//  HealthAppApp.swift
//  HealthApp
//
//  Created by Eric Li on 12/11/2023.
//

import SwiftUI

@main
struct HealthAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
