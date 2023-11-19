//
//  CalendarView.swift
//  HealthApp
//
//  Created by Chan King Yeung on 11/16/23.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var dayStore: DayStore
    @State private var draggingItem = 0.0
    @State private var showingPopover = false
    init(dayStore: DayStore) {
        self.dayStore = dayStore
    }
     
    var body: some View {
        ZStack {
            Button(action: {
                showingPopover = true
            }, label: {
                Text(dayStore.dateToString(date: dayStore.currentDate, format: "Y"))
                    .font(.system(size: 40))
                    .bold()
            })
            .tint(.black)
            .popover(isPresented: $showingPopover, attachmentAnchor: .point(.top), arrowEdge: .bottom) {
                VStack {
                    DatePicker("Date", selection: $dayStore.currentDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                }
                .frame(width: 250)
                .presentationCompactAdaptation(.popover)
                
            }
            .offset(y:-70)
            .onChange(of: dayStore.currentDate) {
                showingPopover = false
                dayStore.setDate(date: dayStore.currentDate)
            }
            ForEach(dayStore.Days) { day in
                VStack {
                    VStack {
                        Text(dayStore.dateToString(date: day.date, format: "d MMM"))
                            .font(.system(size:14))
                            .frame(maxWidth:.infinity)
                        Circle()
                            .frame(width: dotSize(day.id))
                    }
                    .onTapGesture {
                        // Updating Current Day
                        dayStore.setDate(date: day.date)
                    }
                }
                .offset(x: XOffset(day.id), y: YOffset(XOffset(day.id)))
                .padding(.horizontal, 20)
            }
        }
        .frame(height: 180)
//        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
        .background(
            Ellipse()
                .strokeBorder(.black, lineWidth: 5)
                .frame(width: 608, height: 223)
                .offset(y: 113)
        )
        .gesture(
            DragGesture()
                .onChanged { value in
                    draggingItem = value.translation.width / 400
                }
                .onEnded { value in
                    withAnimation {
                        if value.predictedEndTranslation.width > 0 {
                            dayStore.update(offset: Int(1))
                        } else {
                            dayStore.update(offset: Int(-1))
                        }
                    }
                    draggingItem = 0
                }
        )
    }
       
    func dotSize(_ item: Int) -> CGFloat {
        if (item == 0) {
            return 35 - abs(draggingItem) * 30
        } else if (item == 1) {
            return 20 - draggingItem * 35
        } else if (item == -1) {
            return 20 + draggingItem * 35
        } else {
            return 20
        }
    }
    
    func YOffset(_ offset_x: Double) -> Double {
        let offset_y = sqrt((1 - pow(offset_x, 2) / pow(304, 2)) * pow(112, 2)) - 103
        return -offset_y
    }
    
    func XOffset(_ item: Int) -> Double {
        return Double(draggingItem * 240 + 120 * Double(item))
    }
}
