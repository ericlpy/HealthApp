//
//  SportRecordRow.swift
//  HealthApp
//
//  Created by Chan King Yeung on 11/18/23.
//

import SwiftUI

struct SportRecordRow: View {
    @ObservedObject var record: SportsRecord

    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                HStack {
                    Text(record.name ?? "")
                        .lineLimit(nil)
                        .frame(minWidth: .zero, maxWidth: 115, minHeight: .zero, maxHeight: .zero)
                        .fixedSize(horizontal: true, vertical: false)
                    Text("-")
                    Text(record.venue ?? "")
                        .lineLimit(nil)
                        .frame(minWidth: .zero, maxWidth: 115, minHeight: .zero, maxHeight: .zero)
                        .fixedSize(horizontal: true, vertical: false)
                }
                Divider().frame(maxWidth: 100)
                ScrollView(.horizontal) {
                    HStack {
                        if let sports = record.sports {
                            ForEach(Array(sports as! Set<Sport>), id: \.self) { sport in
                                VStack {
                                    if let image = sport.image {
                                        Image(image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .clipShape(.circle)
                                            .overlay(Circle().stroke(Color.black, lineWidth: 1))
                                    }
                                    if sport.set != 0 {
                                        Text(String(sport.set))
                                            .lineLimit(1)
                                            .fixedSize(horizontal: true, vertical: false)
                                    } else {
                                        Text(String(sport.duration) + " min")
                                            .lineLimit(1)
                                            .fixedSize(horizontal: true, vertical: false)
                                    }
                                }
                                .padding(.trailing)
                            }
                        }
                    }
                }
            }
            .padding([.top, .leading, .bottom])
            Spacer()
            VStack {
                if let date = record.date {
                    Text(getTime(date: date))
                        .font(.largeTitle)
                }
                Text("Total Calories")
                    .lineLimit(nil)
                    .frame(minWidth: .zero, maxWidth: 105, minHeight: .zero, maxHeight: .zero)
                    .fixedSize(horizontal: true, vertical: false)
                if let sports = record.sports {
                    Text(getTotalCalories(array: Array(sports as! Set<Sport>)))
                        .font(.system(size: 30))
                        .bold()
                }
            }
            .padding(.trailing)
        }
        .background(Color(red: 0.816, green: 0.8941176470588236, blue: 0.984313725490196))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .frame(maxWidth: .infinity)
        .overlay(RoundedRectangle(cornerRadius: 25)
            .fill( record.finished ? Color(red: 0.204, green: 0.78, blue: 0.349, opacity: 0.5) : Color(white: 0, opacity: 0.0)))
    }
    
    func getTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func getTotalCalories(array: Array<Sport>) -> String {
        var totalCalories: Float = 0
        for sport in array {
            totalCalories += sport.calorieBurned
        }
        return String(format: "%.2f", totalCalories)
    }
}

#Preview {
    SportRecordRow(record: testingData())
}

//var persistenceController = PersistenceController.shared
func testingData() -> SportsRecord {
    let viewContext = persistenceController.container.viewContext
    let newItem = SportsRecord(context: viewContext)
    newItem.name = "6:00pm"
    newItem.date = Date()
    newItem.venue = "Gym"
    
    let sport = Sport(context: viewContext)
    let sport2 = Sport(context: viewContext)
    let sport3 = Sport(context: viewContext)
    let sport4 = Sport(context: viewContext)
    sport.name = "Lifting"
    sport.image = "weightLifting"
    sport.set = 10
    sport.calorieBurned = 23.6
    sport2.name = "Hard"
    sport2.image = "pullDowning"
    sport2.duration = 20
    sport2.calorieBurned = 46.32
    sport3.name = "Lifting"
    sport3.image = "weightLifting"
    sport3.set = 10
    sport3.calorieBurned = 23.6
    sport4.name = "Lifting"
    sport4.image = "weightLifting"
    sport4.set = 10
    sport4.calorieBurned = 23.6
    newItem.finished = false
    newItem.sports = NSSet(array: [sport, sport2, sport3, sport4])
    
    return newItem
}
