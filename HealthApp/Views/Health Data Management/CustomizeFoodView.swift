//
//  CustomizeFoodView.swift
//  HealthApp
//
//  Created by Hui Chak Yan on 11/19/23.
//

import SwiftUI

struct CustomizeFoodView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var customizedFoodArray: [Food]
    @State var customizedFood: Food?
    @State var tmp_array: [Food]?
    @State var number: Int
    @State var choice: String
    
    let choices = ["Set", "Duration"]
    
    var threeColumnGrid = [GridItem(.flexible()),
                           GridItem(.flexible()),
                           GridItem(.flexible())]
    
    @State var name = ""
    
    init(customizedFoodArray: Binding<[Food]>, customizedFood: Food?) {
        _selectedSportsArray = customizedFoodArray
        if let customizedFood {
            _name = State(initialValue: customizedFood.name!)
            _selectedSport = State(initialValue: customizedFood)
            if customizedFood.set != 0 {
                _number = State(initialValue: Int(customizedFood.set))
                _choice = State(initialValue: "Set")
            } else {
                _number = State(initialValue: Int(customizedFood.duration))
                _choice = State(initialValue: "Duration")
            }
            _tmp_array = State(initialValue: self.customizedFoodArray.filter({ String($0.name!) != String(customizedFood.name!) }))
        } else {
            _name = State(initialValue: "")
            _selectedSport = State(initialValue: nil)
            _number = State(initialValue: 1)
            _choice = State(initialValue: "Set")
            _tmp_array = State(initialValue: self.customizedFoodArray)
        }
    }
    
    var body: some View {
        let FoodList = modelData.calorieDataTable.filter { $0.type == "food"}
        
        Section {
            LazyVGrid(columns: threeColumnGrid) {
                ForEach(foodList, id: \.name) { item in
                    Button(action: {
                        name = item.name
                    }, label: {
                        Image(item.name)
                            .resizable()
                            .scaledToFit()
                            .clipShape(.circle)
                            .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    })
                    .disabled(tmp_array!.contains(where: { $0.name == item.name }) || name == item.name)
                    .overlay(Circle().fill(Color.gray.opacity(tmp_array!.contains(where: { $0.name == item.name }) || name == item.name ? 0.5 : 0)))
                    .overlay(Image(systemName: "checkmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .opacity(name == item.name ? 1.0 : 0.0))
                }
            }
        }
        Divider()
        ForEach(tmp_array!) { food in
            Text(food.name!)
        }
        Divider()
        
        
        if let customizedFood {
            Text(customizedFood.name!)
        } else {
            Text("No Record")
        }
        Section {
            LabeledContent {
                Picker("", selection: $number) {
                    ForEach(1...1000, id: \.self) {
                        Text("\($0)" + String(choice == "Set" ? "" : " min"))
                    }
                }
                .pickerStyle(.wheel)
            } label: {
                Picker("", selection: $choice) {
                    ForEach(choices, id: \.self) { item in
                        Text(item)
                    }
                }
            }
            .frame(height: 100)
        }
        
        Button("Select"){
            submitItem(calorie: foodList.first(where: {$0.name == name})!.calories)
            dismiss()
        }
        .disabled(name == "")
    }
    
    private func submitItem(calorie: Float) {
        let newFood = Food(context: viewContext)
        newFood.image = name
        newFood.name = name
        if (choice == "Set") {
            newFood.set = Int16(number)
            newFood.calorieGained = calorie * Float(number)
        } else {
            newFood.duration = Int16(number)
            newFood.calorieGained = calorie * Float(number)
        }
        
        tmp_array!.append(newFood)
        customizedFoodArray = tmp_array!
    }
}



var modelData = ModelData()

