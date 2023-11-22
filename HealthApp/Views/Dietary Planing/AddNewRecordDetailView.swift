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

    @State var meal: String = ""
    @State var recordDate: Date = Date()
    
    @State var selectedFood: Food? = nil
    @State var selectedFoodArray: [Food] = []
    @State var numberOfFood: Int = 1
    
    @State var tempArray: [Food]?
    @State var showActivitySheet = false
    
    private func getTotalCalorie(array: [Food]) -> Float{
        var result: Float = 0
        if array.isEmpty {return 0}
        for item in array{
            result += item.calorie
        }
        return result
    }
    
    private func save(){
        let newFoodRecord = FoodRecord(context: viewContext)
        newFoodRecord.id = UUID()
        newFoodRecord.date = recordDate
        newFoodRecord.calorieGained = getTotalCalorie(array: selectedFoodArray)
        newFoodRecord.meal = meal
        let newSet = NSSet().addingObjects(from: selectedFoodArray)
        newFoodRecord.food = newSet as NSSet

        do  {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    var body: some View {
        Text("New record")
            .font(.largeTitle)
            .bold()
        Form{
            Section(header:Text("Meal detail")){
                LabeledContent {
                    TextField("", text: $meal)
                        .frame(maxWidth: 210)
                } label: {
                    Text("Meal")
                }
                LabeledContent {
                    DatePicker(selection: $recordDate) {}
                } label: {
                    Text("Time")
                }
            }
            Section(header:Text("Food Detail")){
                Picker("Number of food you ate", selection: $numberOfFood){
                    ForEach(1..<6, id: \.self){ num in
                        Text(String(num))
                    }
                }
            }
            Section(header:Text("Food Detail")){
                ForEach(0..<numberOfFood, id: \.self) { index in
                    Button(action:{
                        showActivitySheet = !showActivitySheet
                    }, label: {
                        if !selectedFoodArray.isEmpty && index < selectedFoodArray.count{
                            HStack {
                                Text("\(selectedFoodArray[index].type!) - \(selectedFoodArray[index].name!)")
                                Spacer()
                                Text(String(format: "%.1f Calories", selectedFoodArray[index].calorie))
                            }.foregroundColor(.black)
                        } else{
                            HStack {
                                Image(systemName: "plus")
                                Text("Add new food / drink")
                            }
                        }
                    })
                    .disabled(index < selectedFoodArray.count)
                }
            }.sheet(isPresented: $showActivitySheet) {
                AddNewFoodView(selectedFoodArray: $selectedFoodArray)
                    .environmentObject(modelData)
            }
            Section(header:Text("Calorie intake")){
                LabeledContent {
                    Text(String(format: "%.1f", getTotalCalorie(array: selectedFoodArray)))
                } label: {
                    Text("Total calorie of this meal")
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
                Button(action: {save();dismiss()}, label: {
                    Text("Save")
                })
                .frame(maxWidth: .infinity)
                .disabled(meal == "" || selectedFoodArray.isEmpty)
            }
        }
        
    }
}

#Preview {
    AddNewRecordDetailView()
}
