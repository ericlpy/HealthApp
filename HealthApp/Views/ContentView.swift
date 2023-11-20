//
//  ContentView.swift
//  HealthApp
//
//  Created by Eric Li on 12/11/2023.
//  testing
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>

    var body: some View {
        VStack {
            TabView {
                ZStack {
                    VStack {
                        HomepageView()
                        Divider()
                    }.padding(.vertical)
                }
                .background(.thinMaterial)
                .tabItem() {
                    Image(systemName: "house")
                }
                ZStack {
                    VStack {
                        DietaryPlaningView()
                        Divider()
                    }.padding(.vertical)
                }
                .background(.thinMaterial)
                .tabItem() {
                    Image(systemName: "fork.knife")
                }
                ZStack {
                    VStack {
                        FitnessTrackingView()
                        Divider()
                    }.padding(.vertical)
                }
                .background(.thinMaterial)
                .tabItem() {
                    Image(systemName: "figure.strengthtraining.traditional")
                }
                    
                ZStack {
                    VStack {
                        HealthDataManagementView()
                        Divider()
                    }.padding(.vertical)
                }
                .background(.thinMaterial)
                .tabItem() {
                    Image(systemName: "heart")
                }
            }.accentColor(.black)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
