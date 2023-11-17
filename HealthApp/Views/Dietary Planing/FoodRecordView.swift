//
//  FoodRecordView.swift
//  HealthApp
//
//  Created by Eric Li on 16/11/2023.
//

import SwiftUI

struct FoodRecordView: View {
    var body: some View {
        ZStack{
            Color.blue
                .opacity(Double(0.2))
                .frame(height: 150)
                .cornerRadius(30)

            HStack {
                VStack(alignment: .leading) {
//                    to be replaced by record
                    Text("Lunch")
                        .font(.title)
                        .bold()
//                    to be replaced by the real photo
//                    only first 2 food will be shown
                    HStack() {
                        Image("cola")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(Color.black, lineWidth: 2))
                        Image("cola")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(Color.black, lineWidth: 2))
                        Image("friedRice")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(Color.black, lineWidth: 2))
                    }
                }
                .padding(15.0)
                Spacer()
                VStack {
                    Text("Total Calories")
                        .bold()
                        .font(.title3)
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
    FoodRecordView()
}
