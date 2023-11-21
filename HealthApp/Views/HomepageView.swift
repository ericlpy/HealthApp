//
//  HomepageView.swift
//  HealthApp
//
//  Created by Chan King Yeung on 14/11/2023.
//

import SwiftUI

struct HomepageView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SportsRecord.date, ascending: true)],
        predicate: NSPredicate(format: "date >= %@ && date <= %@", Calendar.current.startOfDay(for: Date()) as CVarArg, Calendar.current.startOfDay(for: Date() + 86400) as CVarArg),
        animation: .default)
    var records: FetchedResults<SportsRecord>
    
    @FetchRequest(entity: UserRecord.entity(),
                  sortDescriptors: [],
                  animation: .default)
    var userArray: FetchedResults<UserRecord>
    
    @FetchRequest(entity: FoodRecord.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \SportsRecord.date, ascending: true)],
                  predicate: NSPredicate(format: "date >= %@ && date <= %@", Calendar.current.startOfDay(for: Date()) as CVarArg, Calendar.current.startOfDay(for: Date() + 86400) as CVarArg),
                  animation: .default)
    var foodArray: FetchedResults<FoodRecord>
    
    var body: some View {
        VStack {
            Text("Homepage")
                .font(.title2)
                .bold()
            Divider()
            Text("Today's Intake")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .leading])
            HStack {
                VStack {
                    Text("Calories Intaked")
                    Text(String(Int(getCalorieIntaked())) + " cal")
                        .lineLimit(1)
                        .bold()
                        .font(.largeTitle)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Rectangle().fill(Color(red: 1.0, green: 0.6509803921568628, blue: 0.12941176470588237)))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.leading)
                VStack {
                    Text("Target")
                    Text(String(getTargetIntake()) + " cal")
                        .lineLimit(1)
                        .bold()
                        .font(.largeTitle)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Rectangle().fill(Color(red: 1.0, green: 0.6509803921568628, blue: 0.12941176470588237)))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.trailing)
            }
            Text("Today's Work")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .padding(.top, 3)
            HStack {
                ZStack {
                    Circle()
                        .stroke(
                            Color(red: 0.36470588235294116, green: 0.8156862745098039, blue: 0.8196078431372549).opacity(0.5),
                            lineWidth: 15
                        )
                        .frame(width: 100)
                    Circle()
                        .trim(from: 0, to: CGFloat(getCalorieBurned()/(getTargetBurn() == 0 ? 1 : getTargetBurn())))
                        .stroke(
                            Color(red: 0.36470588235294116, green: 0.8156862745098039, blue: 0.8196078431372549),
                            style: StrokeStyle(
                                lineWidth: 15,
                                lineCap: .round
                            )
                        )
                        .frame(width: 100)
                        .rotationEffect(.degrees(-90))
                    Text(String(Int(getCalorieBurned()/(getTargetBurn() == 0 ? 1 : getTargetBurn()) * 100) >= 100 ? 100 : Int(getCalorieBurned()/(getTargetBurn() == 0 ? 1 : getTargetBurn()) * 100)) + "%")
                        .foregroundColor(Color(red: 0.36470588235294116, green: 0.8156862745098039, blue: 0.8196078431372549))
                        .font(.system(size: 30))
                        .bold()
                }
                .padding(.leading, 25)
                .padding(.trailing)
                
                VStack (alignment: .leading){
                    Text("Calories burned")
                        .bold()
                    Text(String(format: "%.2f cal ",getCalorieBurned()))
                        .bold()
                        .font(.largeTitle)
                        .frame(maxWidth:.infinity, alignment: .trailing)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(red: 0.36470588235294116, green: 0.8156862745098039, blue: 0.8196078431372549))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.trailing)

                    Text("Target burn")
                        .bold()
                    Text(String(getTargetBurn()) + " cal")
                        .bold()
                        .font(.largeTitle)
                        .frame(maxWidth:.infinity, alignment: .trailing)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(red: 0.36470588235294116, green: 0.8156862745098039, blue: 0.8196078431372549))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.trailing)
                    
                }
            }
            Text("Time to start your work")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            Image("poster")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).fill(.white).shadow(color: Color.black.opacity(0.5), radius: 6, x: 0, y: 3))
                
                .padding([.leading, .bottom, .trailing])
            Spacer()
            
            
        }
    }
    
    func getCalorieBurned() -> Float {
        var calorieBurned: Float = 0
        for record in records {
            if record.finished {
                for sport in Array(record.sports! as! Set<Sport>) {
                    if (sport.set != 0) {
                        calorieBurned += sport.calorieBurned * Float(sport.set)
                    } else {
                        calorieBurned += sport.calorieBurned * Float(sport.duration)
                    }
                }
            }
        }
        return calorieBurned
    }
    
    func getCalorieIntaked() -> Float {
        var calorieIntaked: Float = 0
        for record in foodArray {
            calorieIntaked += Float(record.calorieGained)
        }
        return calorieIntaked
    }
    
    func getTargetBurn() -> Float {
        if userArray.count == 0 {
            return 0
        } else {
            return userArray[0].calorieBurnedPerDay
        }
    }
    
    func getTargetIntake() -> Float {
        if userArray.count == 0 {
            return 0
        } else {
            return userArray[0].calorieIntakePerDay
        }
    }
}

#Preview {
    HomepageView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
