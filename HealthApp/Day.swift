//
//  Day.swift
//  HealthApp
//
//  Created by Chan King Yeung on 11/16/23.
//

import Foundation

struct DayValue: Identifiable {
    var id: Int
    var date: Date
}

class DayStore: ObservableObject {
    @Published var Days: [DayValue] = []
    @Published var currentDate: Date = Date()
    @Published var currentIndex: Int = 0
    init() {
        appendAll()
    }
    
    func appendAll() {
        var newDay = DayValue(id: 0, date: currentDate)
        Days.append(newDay)
        
        newDay = DayValue(id: 1, date: currentDate.addingTimeInterval(60*60*24))
        Days.append(newDay)
        
        newDay = DayValue(id: 2, date: currentDate.addingTimeInterval(60*60*24*2))
        Days.append(newDay)
        
        newDay = DayValue(id: -1, date: currentDate.addingTimeInterval(-60*60*24))
        Days.append(newDay)

        newDay = DayValue(id: -2, date: currentDate.addingTimeInterval(-60*60*24*2))
        Days.append(newDay)
    }
    
    func update(offset: Int) {
        if offset == -1 {
            currentIndex += 1
            currentDate = currentDate.addingTimeInterval(60*60*24)
        } else if offset == 1 {
            currentIndex -= 1
            currentDate = currentDate.addingTimeInterval(-60*60*24)
        }
    }
    
    func setDate(date: Date) {
        currentDate = date
        Days.removeAll()
        appendAll()
    }
    
    func dateToString(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
