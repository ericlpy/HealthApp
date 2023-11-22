//
//  AddNewFoodView.swift
//  HealthApp
//
//  Created by Eric Li on 20/11/2023.
//

import SwiftUI

struct AddNewFoodView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var selectedFoodArray: [Food]
    
    @State var type:String = ""
    @State var name:String = ""
    @State var amount:Int = 0
    @State var calorieIntake: Float = 0
    
    private func submitItem(calorie: Float) {
        let newFood = Food(context: viewContext)
        newFood.type = type
        newFood.name = name
        newFood.amount = Int16(amount)
        newFood.calorie = calorie
        selectedFoodArray.append(newFood)
    }
    
    var body: some View {
        let foodList = modelData.calorieDataTable.filter { $0.type == "Food"}
        let drinkList = modelData.calorieDataTable.filter { $0.type == "Drink"}
        let list = modelData.calorieDataTable.filter { $0.type == "Food" || $0.type == "Drink"}

        Text("Add new food / drink")
            .font(.title)
            .bold()
            .padding()
        Form(content: {
            Section{
                Picker(selection: $type, label: Text("Type")){
                    ForEach(["Food", "Drink"], id: \.self){ type in
                        Text(type)
                    }
                }
                if type != ""{
                    Picker(selection: $name, label: Text("Name")) {
                        type == "Food"
                        ? ForEach(foodList, id: \.name) { item in
                            Text(item.name)
                        }
                        : ForEach(drinkList, id: \.name) { item in
                            Text(item.name)
                        }
                    }
                }
                if name != "" {
                    Picker(selection: $amount, label: Text("Amount")){
                        ForEach(Array(stride(from: 10, to: 2001, by: 10)), id: \.self){ amount in
                            type == "Food" ? Text("\(amount)g") : Text("\(amount)mL")
                        }
                    }
                }
            }
            
            if amount != 0 {
                Section(header: Text("Expected calorie intake")){
                    Text(String(format: "%.1f Calories", list.first(where: {$0.name == name})!.calories * Float(amount)/100))
                }
            }
            Button("Add"){
                submitItem(calorie: list.first(where: {$0.name == name})!.calories * Float(amount)/100)
                dismiss()
            }
            .frame(maxWidth: .infinity)
            .disabled(type == "" || name == "" || amount == 0)
        })
    }
}

//#Preview {
//    AddNewFoodView()
//        .environmentObject(ModelData())
//}
