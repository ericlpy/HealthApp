//
//  DietaryPlaningView.swift
//  HealthApp
//
//  Created by Eric Li on 14/11/2023.
//

import SwiftUI

struct DietaryPlaningView: View {
    
//    @EnvironmentObject var modelData:ModelData
    @State var showAddSheet: Bool = false
    @State var selectedRecord:FoodRecord? = nil
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FoodRecord.id, ascending: true)],
        animation: .default)
    private var foodRecords: FetchedResults<FoodRecord>
    
    var body: some View {
        Text("Food Diary")
            .font(.title2)
            .bold()
        Divider()
        ScrollView(showsIndicators: false, content: {
            ForEach(foodRecords){ record in
                Button(action: {
                    selectedRecord = record
                }, label: {
                    FoodRecordView(foodRecord: record)
                }).foregroundColor(Color(.black))
            }
            Button(action: {
                selectedRecord = nil
                showAddSheet = true
            }, label: {
                AddNewRecordView()
            }).fullScreenCover(isPresented: $showAddSheet, content: {
                AddNewRecordDetailView()
            })
        })
        .padding(.horizontal)
        .sheet(item: $selectedRecord){ record in
            FoodRecordDetailView(foodRecord: record)
        }
    }
}

#Preview {
    DietaryPlaningView()
//        .environmentObject(ModelData())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
