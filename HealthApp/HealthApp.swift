//
//  HealthApp.swift
//  HealthApp
//
//  Created by Eric Li on 12/11/2023.
//

import SwiftUI

@main
struct HealthApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(modelData)
        }
    }
}
