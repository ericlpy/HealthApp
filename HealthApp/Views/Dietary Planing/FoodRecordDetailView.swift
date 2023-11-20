//
//  FoodRecordDetailView.swift
//  HealthApp
//
//  Created by Eric Li on 17/11/2023.
//

import SwiftUI

struct FoodRecordDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State var foodRecord: FoodRecord?
    
    @State var meal = ""
    @State var date = Date()
    @State var calorieGained = 0
    @State var amount = 0
    
    var body: some View {
        Text(foodRecord!.meal!)
            .font(.largeTitle)
            .bold()
        Divider()
        Spacer()
            
        Button("Save"){
            dismiss()
        }
        
    }
}

#Preview {
    FoodRecordDetailView()
}
