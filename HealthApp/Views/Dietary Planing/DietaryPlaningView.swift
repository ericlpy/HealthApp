//
//  DietaryPlaningView.swift
//  HealthApp
//
//  Created by Eric Li on 14/11/2023.
//

import SwiftUI

struct DietaryPlaningView: View {
    @EnvironmentObject var modelData:ModelData
    @State var showSheet = false
    var body: some View {
        Text("Food Diary")
            .font(.title2)
            .bold()
        Divider()
//            Text(modelData.calorieDataTable[0].name)
        NavigationStack{
            ScrollView{
//                List(modelData.calorieDataTable){ record in
//                    NavigationLink(destination: FoodRecordDetailView()) {
//                        FoodRecordView()
//                    }
//                }
                Button(action: {showSheet = !showSheet}, label: {
                    FoodRecordView()
                }).foregroundColor(Color(.black))
            }
        }
        .padding()
        .sheet(isPresented: $showSheet, content: {
            FoodRecordDetailView()
        })
    }
}

#Preview {
    DietaryPlaningView()
        .environmentObject(ModelData())
}
