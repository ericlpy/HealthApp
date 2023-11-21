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
    
    @FetchRequest(entity: UserRecord.entity(),
                  sortDescriptors: [],
                  animation: .default)
    var userArray: FetchedResults<UserRecord>
    
    var body: some View {
        VStack {
            TabView {
                ZStack {
                    VStack {
                        HomepageView()
                            .environment(\.managedObjectContext, viewContext)
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
                            .environment(\.managedObjectContext, viewContext)
                        Divider()
                    }.padding(.vertical)
                }
                .background(.thinMaterial)
                .tabItem() {
                    Image(systemName: "fork.knife")
                }
                ZStack {
                    VStack {
                        if checkUser() {
                            FitnessTrackingView()
                                .environment(\.managedObjectContext, viewContext)
                        } else {
                            ChoosePlanView(planExist: userArray.isEmpty).environment(\.managedObjectContext, viewContext)
                        }
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
                            .environment(\.managedObjectContext, viewContext)
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
    
    private func checkUser() -> Bool {
        if userArray.isEmpty {
            return false
        } else if userArray[0].chosenPlan == nil {
            return false
        } else {
            return true
        }
    }
}


private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static let controller = PersistenceController.preview
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, controller.container.viewContext)
    }
}
