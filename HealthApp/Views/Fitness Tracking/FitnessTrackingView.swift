//
//  FitnessTrackingView.swift
//  HealthApp
//
//  Created by Chan King Yeung on 14/11/2023.
//

import SwiftUI

struct FitnessTrackingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var dayStore = DayStore()
    @State var currentDate: Date = Date()
    @State var showSheet = false
    @State var selectedItem: SportsRecord?
    
    @FetchRequest(
        entity: SportsRecord.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \SportsRecord.date, ascending: true)],
        predicate: NSPredicate(format: "date >= %@ && date <= %@", Calendar.current.startOfDay(for: Date()) as CVarArg, Calendar.current.startOfDay(for: Date() + 86400) as CVarArg),
        animation: .default)
    var records: FetchedResults<SportsRecord>
    
    @FetchRequest(entity: UserRecord.entity(),
                  sortDescriptors: [],
                  animation: .default)
    var userArray: FetchedResults<UserRecord>
    
    var body: some View {
        VStack {
            Text("Fitness Tracking")
                .font(.title2)
                .bold()
            Divider()
            List {
                ForEach(records, id: \.self) { item in
                    Button(action: {
                        selectedItem = item
                    }, label: {
                        SportRecordRow(record: item)
                            .foregroundColor(.black)
                    })
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, -10)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .swipeActions(edge: .leading) {
                        Button {
                            finishRecord(record: item)
                        } label: {
                            Text("Done")
                                .bold()
                        }
                        .tint(.green)
                    }
                }
                .onDelete(perform: deleteItems)
                .frame(alignment: .leading)
                Button(action: {
                    showSheet = true
                }, label: {
                    ZStack {
                        Color.gray
                            .opacity(0.2)
                            .frame(height: 140)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                        Image(systemName: "plus.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                    }.padding(.horizontal, -10)
                })
            }
            .listStyle(.plain)
            .sheet(item: $selectedItem, content: { item in
                SportRecordDetailView(record: item, time: nil)
                    .environmentObject(modelData)
            })
            .sheet(isPresented: $showSheet, content: {
                SportRecordDetailView(record: nil, time: dayStore.currentDate)
                    .environmentObject(modelData)
            })
            Spacer()
            CalendarView(dayStore: dayStore)
                .onChange(of: dayStore.currentDate) {
                    records.nsPredicate = makeDatePredicate(currentDate: dayStore.currentDate)
                }
        }
//        .onAppear {
//            addWeekDayExercise()
//        }
        .onChange(of: dayStore.currentDate) {
            addWeekDayExercise()
        }
    }
    
    private func addWeekDayExercise() {
        let newSport1 = Sport(context: viewContext)
        newSport1.name = "pullDowning"
        newSport1.image = "pullDowning"
        newSport1.set = 30
        newSport1.calorieBurned = 660
        
        let newSport2 = Sport(context: viewContext)
        newSport2.name = "weightLifting"
        newSport2.image = "weightLifting"
        newSport2.set = 10
        newSport2.calorieBurned = 100
        
        let newSport3 = Sport(context: viewContext)
        newSport3.name = "benchPressing"
        newSport3.image = "benchPressing"
        newSport3.set = 20
        newSport3.calorieBurned = 32
        
        var Array1 = Array<Sport>()
        Array1.append(newSport1)
        
        var Array2 = Array<Sport>()
        Array2.append(newSport2)
        Array2.append(newSport3)
        
        switch dayStore.dateToString(date: dayStore.currentDate, format: "EEEE") {
        case "Monday":
            if userArray[0].mon?.count != 0 {
                let r = SportsRecord(context: viewContext)
                r.sports = NSSet().addingObjects(from: Array1) as NSSet
                r.date = dayStore.currentDate
                r.name = userArray[0].chosenPlan
                r.venue = "Home"
                r.finished = false
                r.id = UUID()
            }
        case "Tuesday":
            if userArray[0].tue?.count != 0 {
                let r = SportsRecord(context: viewContext)
                r.sports = NSSet().addingObjects(from: Array2) as NSSet
                r.date = dayStore.currentDate
                r.name = userArray[0].chosenPlan
                r.venue = "Home"
                r.finished = false
                r.id = UUID()
            }
        case "Wednesday":
            if userArray[0].wed?.count != 0 {
                let r = SportsRecord(context: viewContext)
                r.sports = NSSet().addingObjects(from: Array1) as NSSet
                r.date = dayStore.currentDate
                r.name = userArray[0].chosenPlan
                r.venue = "Home"
                r.finished = false
                r.id = UUID()
            }
        case "Thursday":
            if userArray[0].thu?.count != 0 {
                let r = SportsRecord(context: viewContext)
                r.sports = userArray[0].thu
                r.date = dayStore.currentDate
                r.name = userArray[0].chosenPlan
                r.venue = "Home"
                r.finished = false
                r.id = UUID()
            }
        case "Friday":
            if userArray[0].fri?.count != 0 {
                let r = SportsRecord(context: viewContext)
                r.sports = NSSet().addingObjects(from: Array2) as NSSet
                r.date = dayStore.currentDate
                r.name = userArray[0].chosenPlan
                r.venue = "Home"
                r.finished = false
                r.id = UUID()
            }
        case "Saturday":
            if userArray[0].sat?.count != 0 {
                let r = SportsRecord(context: viewContext)
                r.sports = userArray[0].sat
                r.date = dayStore.currentDate
                r.name = userArray[0].chosenPlan
                r.venue = "Home"
                r.finished = false
                r.id = UUID()
            }
        case "Sunday":
            if userArray[0].sun?.count != 0 {
                let r = SportsRecord(context: viewContext)
                r.sports = userArray[0].sun
                r.date = dayStore.currentDate
                r.name = userArray[0].chosenPlan
                r.venue = "Home"
                r.finished = false
                r.id = UUID()
            }
        default:
            break
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
    
    private func makeDatePredicate(currentDate: Date) -> NSPredicate {
        let datePredicate = NSPredicate(format: "date >= %@ && date <= %@", Calendar.current.startOfDay(for: currentDate) as CVarArg, Calendar.current.startOfDay(for: currentDate + 86400) as CVarArg)
        return datePredicate
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { records[$0] }.forEach(viewContext.delete)
            
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
    
    private func finishRecord(record: SportsRecord) {
        withAnimation {
            record.finished = true
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
}

struct FitnessTrackingView_Previews: PreviewProvider {
    static let controller = PersistenceController.preview
    static var previews: some View {
        FitnessTrackingView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
