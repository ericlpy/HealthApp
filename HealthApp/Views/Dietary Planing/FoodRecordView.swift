//
//  FoodRecordView.swift
//  HealthApp
//
//  Created by Eric Li on 16/11/2023.
//

import SwiftUI

struct FoodRecordView: View {
    @State var foodRecord: FoodRecord?
    
    private func getTotalCalorie(foodArray: [Food]) -> Float{
        var total: Float = 0
        for food in foodArray{
            total += food.calorie
        }
        return total
    }
    
    var threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        let foodArray = Array(foodRecord!.food! as! Set<Food>)
        if foodArray.count > 3 {
            ZStack{
                Color.blue
                    .opacity(Double(0.2))
                    .frame(height: 250)
                    .cornerRadius(30)
                HStack {
                    VStack(alignment: .leading) {
                        Text(foodRecord!.meal!)
                            .font(.title)
                            .bold()
                        HStack() {
                            LazyVGrid(columns: threeColumnGrid) {
                                ForEach(foodArray){ food in
                                    Image(food.name!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                        .shadow(radius: 10)
                                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                                }
                                
                            }
                        }
                    }
                    .padding(15.0)
                    Spacer()
                    VStack {
                        Text("Total Calories")
                            .bold()
                            .font(.title3)
                        Text(String(format: "%.1f", getTotalCalorie(foodArray: foodArray)))
                            .bold()
                            .font(.largeTitle)
                    }
                    .frame(minWidth: 100)
                    
                }
                .padding()
                .frame(height: 150.0)
            }
        } else {
            ZStack{
                Color.blue
                    .opacity(Double(0.2))
                    .frame(height: 150)
                    .cornerRadius(30)
                HStack {
                    VStack(alignment: .leading) {
                        Text(foodRecord!.meal!)
                            .font(.title)
                            .bold()
                        HStack() {
                            LazyVGrid(columns: threeColumnGrid) {
                                ForEach(foodArray){ food in
                                    Image(food.name!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                        .shadow(radius: 10)
                                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                                }
                            }
                        }
                    }
                    .padding(15.0)
                    Spacer()
                    VStack {
                        Text("Total Calories")
                            .bold()
                            .font(.title3)
                        Text(String(format: "%.1f", getTotalCalorie(foodArray: foodArray)))
                            .bold()
                            .font(.largeTitle)
                    }
                    .frame(minWidth: 100)
                    
                }
                .padding()
                .frame(height: 150.0)
            }
        }
    }
}

#Preview {
    FoodRecordView(foodRecord: testingData())
}

var persistenceController=PersistenceController.shared
func testingData() -> FoodRecord {
    let viewContext = persistenceController.container.viewContext
    let newItem = FoodRecord(context: viewContext)
    let food1 = Food(context: viewContext)
    let food2 = Food(context: viewContext)
    food1.name = "cola"
    food2.name = "friedRice"
    newItem.calorieGained = 100
    newItem.date = Date()
    newItem.id = UUID()
    newItem.meal = "Lunch"
    newItem.food = NSSet(array: [food1, food2])
    
    return newItem
}
