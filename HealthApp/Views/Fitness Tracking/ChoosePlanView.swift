//
//  ChoosePlanView.swift
//  HealthApp
//
//  Created by user249496 on 11/20/23.
//

import SwiftUI

struct ChoosePlanView: View {
    
    var twoColumnGrid = [GridItem(.flexible()),
                         GridItem(.flexible())]
    
    var planName = ["Workout for Men", "Workouts for Women", "Fat Loss", "Muscle Building"]
    var planList = ["workoutsForMen", "workoutsForWomen", "fatLoss", "muscleBuilding"]
    @State var startChoosing: Bool = false
    @State var selectedItem: String? = ""
    
    var body: some View {
        if !startChoosing {
            VStack {
                Text("You don't have any plan yet")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                Button("Choose your plan now") {
                    withAnimation() {
                        startChoosing = true
                    }
                }
                .multilineTextAlignment(.center)
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                .padding(30)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(30)
                .padding()
            }
        } else {
            VStack {
                Text("Choose your plan:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                LazyVGrid(columns: twoColumnGrid, spacing: 20) {
                    ForEach(planList.indices, id: \.self) { index in
                        Button(action: {
                            selectedItem = planName[index]
                        }, label: {
                            VStack {
                                Image(planList[index])
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                                    .background(RoundedRectangle(cornerRadius: 25).fill(.white).shadow(color: Color.black.opacity(0.5), radius: 6, x: 0, y: 3))
                                    .padding(.horizontal, 10)
                                Text(planName[index])
                            }
                        })
                    }
                }
                
                //                .sheet(item: $selectedItem, content: { plan in
                //                    PlanDetailView(plan: plan)
                //                })
            }
        }
    }
}

#Preview {
    ChoosePlanView()
}
