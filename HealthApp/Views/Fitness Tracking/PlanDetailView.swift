//
//  PlanDetailView.swift
//  HealthApp
//
//  Created by user249496 on 11/20/23.
//

import SwiftUI

struct PlanDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var planExist: Bool
    @FetchRequest(entity: UserRecord.entity(),
                  sortDescriptors: [],
                  animation: .default)
    var userArray: FetchedResults<UserRecord>
    @Binding var plan: String
    
    
    let sample_sport = ["mon": ["pullDowning"],
                        "tue": ["benchPressing", "weightLifting"],
                        "wed": ["pullDowning"],
                        "thu": [],
                        "fri": ["benchPressing", "weightLifting"],
                        "sat": [],
                        "sun": []]
    
    let sample_number = ["mon": ["30"],
                         "tue": ["10", "20"],
                         "wed": ["30"],
                         "thu": [],
                         "fri": ["10", "20"],
                         "sat": [],
                         "sun": []]
    
    
    var body: some View {
        Text("You select plan: " + plan)
        Text("Here is the suggested plan for training")
        HStack {
            VStack (alignment: .leading) {
                HStack {
                    Text("Mon & Wed")
                        .lineLimit(nil)
                        .frame(minWidth: .zero, maxWidth: 115, minHeight: .zero, maxHeight: .zero)
                        .fixedSize(horizontal: true, vertical: false)
                }
                Divider().frame(maxWidth: 100)
                ScrollView(.horizontal) {
                    HStack {
                        VStack {
                            Image("pullDowning")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(.circle)
                                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                            Text("30")
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        .padding(.trailing)
                        
                    }
                }
            }
            .padding([.top, .leading, .bottom])
            Spacer()
        }
        .background(Color(red: 0.816, green: 0.8941176470588236, blue: 0.984313725490196))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .frame(maxWidth: .infinity)
        .padding()
        HStack {
            VStack (alignment: .leading) {
                HStack {
                    Text("Tue & Fri")
                        .lineLimit(nil)
                        .frame(minWidth: .zero, maxWidth: 115, minHeight: .zero, maxHeight: .zero)
                        .fixedSize(horizontal: true, vertical: false)
                }
                Divider().frame(maxWidth: 100)
                ScrollView(.horizontal) {
                    HStack {
                        VStack {
                            Image("weightLifting")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(.circle)
                                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                            Text("10")
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        .padding(.trailing)
                        VStack {
                            Image("benchPressing")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(.circle)
                                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                            Text("20")
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        .padding(.trailing)
                    }
                }
            }
            .padding([.top, .leading, .bottom])
            Spacer()
        }
        .background(Color(red: 0.816, green: 0.8941176470588236, blue: 0.984313725490196))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .frame(maxWidth: .infinity)
        .padding()
        Button("Submit") {
            submitPlan(plan: plan)
            dismiss()
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.blue)
        .cornerRadius(40)
        .padding()
    }
    
    private func submitPlan(plan: String) {
        
        let newSport1 = Sport(context: viewContext)
        newSport1.name = "pullDowning"
        newSport1.image = "pullDowning"
        newSport1.set = 30
        newSport1.calorieBurned = 22
        
        let newSport2 = Sport(context: viewContext)
        newSport2.name = "weightLifting"
        newSport2.image = "weightLifting"
        newSport2.set = 10
        newSport2.calorieBurned = 22
        
        let newSport3 = Sport(context: viewContext)
        newSport3.name = "benchPressing"
        newSport3.image = "benchPressing"
        newSport3.set = 20
        newSport3.calorieBurned = 22
        
        var Array1 = Array<Sport>()
        Array1.append(newSport1)
        
        var Array2 = Array<Sport>()
        Array2.append(newSport2)
        Array2.append(newSport3)
        
        if !userArray.isEmpty {
            userArray[0].chosenPlan = plan
            userArray[0].mon = NSSet().addingObjects(from: Array1) as NSSet
            userArray[0].wed = NSSet().addingObjects(from: Array1) as NSSet
            
            userArray[0].tue = NSSet().addingObjects(from: Array2) as NSSet
            userArray[0].fri = NSSet().addingObjects(from: Array2) as NSSet
            
            userArray[0].calorieBurnedPerDay = 1000
            userArray[0].calorieIntakePerDay = 1000
        } else {
            let newUser = UserRecord(context: viewContext)
            newUser.id = UUID()
            newUser.chosenPlan = plan
            newUser.mon = NSSet().addingObjects(from: Array1) as NSSet
            newUser.wed = NSSet().addingObjects(from: Array1) as NSSet
            
            newUser.tue = NSSet().addingObjects(from: Array2) as NSSet
            newUser.fri = NSSet().addingObjects(from: Array2) as NSSet
            
            newUser.calorieBurnedPerDay = 1000
            newUser.calorieIntakePerDay = 1000
        }

        do  {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

//#Preview {
//    PlanDetailView()
//}
