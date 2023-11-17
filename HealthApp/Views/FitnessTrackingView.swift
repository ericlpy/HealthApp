//
//  FitnessTrackingView.swift
//  HealthApp
//
//  Created by Sunny on 14/11/2023.
//

import SwiftUI

struct FitnessTrackingView: View {
    @ObservedObject var dayStore = DayStore()
    var body: some View {
        VStack {
            Text("Fitness Tracking")
                .font(.title2)
                .bold()
            Text(dateToString(date: dayStore.currentDate, format: "d"))
            Divider()
            Spacer()
            CalendarView(dayStore: dayStore)
        }
    }
}

func dateToString(date: Date, format: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: date)
}

#Preview {
    FitnessTrackingView()
}
