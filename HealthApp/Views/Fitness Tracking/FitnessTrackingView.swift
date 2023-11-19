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
    @State var showActivitySheet = false
    @State var selectedItem: SportsRecord?
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SportsRecord.date, ascending: true)],
        predicate: NSPredicate(format: "date >= %@ && date <= %@", Calendar.current.startOfDay(for: Date()) as CVarArg, Calendar.current.startOfDay(for: Date() + 86400) as CVarArg),
        animation: .default)
    var records: FetchedResults<SportsRecord>
    var body: some View {
        VStack {
            Text("Fitness Tracking")
                .font(.title2)
                .bold()
            Divider()
//            NavigationView {
                List {
                    ForEach(records.indices, id: \.self) { index in
                        Button(action: {
                            selectedItem = records[index]
                        }, label: {
                            if (!records[index].isDeleted) {
                                SportRecordRow(record: records[index])
                                    .foregroundColor(.black)
                            }
                        })
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, -10)
                        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .swipeActions(edge: .leading) {	
                            Button {
                                finishRecord(record: records[index])
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
                        showActivitySheet = true
                    }, label: {
                        Text("+")
                    })
                }
                .listStyle(.plain)
                .sheet(item: $selectedItem, content: { item in
                    SportRecordDetailView(record: item)
                        .environmentObject(modelData)
//                        .presentationDetents([.large, .medium, .fraction(0.55)])
                })
                .sheet(isPresented: $showActivitySheet, content: {
                    SportRecordDetailView(record: nil)
                        .environmentObject(modelData)
                })
//            }
            Spacer()
            CalendarView(dayStore: dayStore)
                .onChange(of: dayStore.currentDate) {
                    records.nsPredicate = makeDatePredicate(currentDate: dayStore.currentDate)
                }
        }
    }
    
    private func makeDatePredicate(currentDate: Date) -> NSPredicate {
        let datePredicate = NSPredicate(format: "date >= %@ && date <= %@", Calendar.current.startOfDay(for: currentDate) as CVarArg, Calendar.current.startOfDay(for: currentDate + 86400) as CVarArg)
        return datePredicate
    }
    
//    private func makeNewPredicate(currentDate: Date) -> NSPredicate {
//        let datePredicate = NSPredicate(format: "date >= %@ && date <= %@ && isDelete == false", Calendar.current.startOfDay(for: currentDate) as CVarArg, Calendar.current.startOfDay(for: currentDate + 86400) as CVarArg)
//        return datePredicate
//    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
//            print(offsets[0])
            offsets.map { records[$0] }.forEach(viewContext.delete)

            do  {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
//            records.nsPredicate.
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


#Preview {
    FitnessTrackingView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}