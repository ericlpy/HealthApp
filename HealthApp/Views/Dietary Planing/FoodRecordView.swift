//
//  FoodRecordView.swift
//  HealthApp
//
//  Created by Eric Li on 16/11/2023.
//

import SwiftUI

struct FoodRecordView: View {
    @State var foodRecord: FoodRecord?
    
    var body: some View {
        let foodArray = Array(foodRecord!.food! as! Set<Food>)
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
                .padding(15.0)
                Spacer()
                VStack {
                    Text("Total Calories")
                        .bold()
                        .font(.title3)
//                    to be amend
                    Text("100")
                        .bold()
                        .font(.largeTitle)
                }
                
            }
            .padding()
            .frame(height: 150.0)
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
