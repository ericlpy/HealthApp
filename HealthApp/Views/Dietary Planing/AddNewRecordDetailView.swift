//
//  AddNewRecordDetailView.swift
//  HealthApp
//
//  Created by Eric Li on 18/11/2023.
//

import SwiftUI

struct AddNewRecordDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State var amount: Int = 0
    @State var calorieGain: Int = 0
    @State var meal: String = ""
    @State var recordDate: Date = Date()
    
    @State var numberOfFood:Int = 0
    @State var selectedFood: Food? = nil
    @State var selectedFoodsArray: [Food] = []
    
    
    var body: some View {
        
        Text("New record")
            .font(.largeTitle)
            .bold()
        Form{
            Section(header:Text("Meal detail")){
                LabeledContent {
                    TextField("", text: $meal)
                } label: {
                    Text("Meal detail")
                }
                LabeledContent {
                    DatePicker(selection: $recordDate) {}
                } label: {
                    Text("Time")
                }
            }
            Section(header:Text("Food Detail")){
                Picker(selection: $numberOfFood, label: Text("Kinds of food")){
                    ForEach(1..<6) { num in
                        Text("\(num)")
                    }
                }
            }
            Section {
                Button(action: {dismiss()}, label: {
                    Text("Cancel")
                        .foregroundStyle(.red)
                })
                .frame(maxWidth: .infinity)
            }
            Section {
                Button(action: {dismiss()}, label: {
                    Text("Save")
                })
                .frame(maxWidth: .infinity)
            }
            
        
        }
//        .scrollContentBackground(.hidden)
        
    }
}

#Preview {
    AddNewRecordDetailView()
}
