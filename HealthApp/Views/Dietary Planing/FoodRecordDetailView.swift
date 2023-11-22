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
    
    func getDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM"
        return dateFormatter.string(from: date)
    }
    
    func getTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        let foodArray = Array(foodRecord!.food! as! Set<Food>)
        
        VStack(alignment: .center) {
            Text(foodRecord!.meal!)
                .font(.largeTitle)
                .bold()
                .padding(.top)
            Text("Date: \(getDate(date: foodRecord!.date!)) Time: \(getTime(date: foodRecord!.date!))")
            Divider()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(foodArray) { food in
                        Image(food.name!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 200)
                    }
                }
            }
            .frame(maxWidth: 350)
            .padding()
        }


    }
}

#Preview {
    FoodRecordDetailView(foodRecord: testingData())
}


