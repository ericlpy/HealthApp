//
//  DietaryPlaningView.swift
//  HealthApp
//
//  Created by Eric Li on 14/11/2023.
//

import SwiftUI

struct GetHeightModifier: ViewModifier {
    @Binding var height: CGFloat

    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geo -> Color in
                DispatchQueue.main.async {
                    height = geo.size.height
                }
                return Color.clear
            }
        )
    }
}

struct DietaryPlaningView: View {
    private func makeDatePredicate(currentDate: Date) -> NSPredicate {
        let datePredicate = NSPredicate(format: "date >= %@ && date <= %@", Calendar.current.startOfDay(for: currentDate) as CVarArg, Calendar.current.startOfDay(for: currentDate + 86400) as CVarArg)
        return datePredicate
    }
    @ObservedObject var dayStore = DayStore()
    @State var showAddSheet: Bool = false
    @State var selectedRecord:FoodRecord? = nil
    @State private var sheetHeight: CGFloat = .zero
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FoodRecord.date, ascending: true)],
        predicate: NSPredicate(format: "date >= %@ && date <= %@", Calendar.current.startOfDay(for: Date()) as CVarArg, Calendar.current.startOfDay(for: Date() + 86400) as CVarArg),
        animation: .default)
    private var foodRecords: FetchedResults<FoodRecord>
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { foodRecords[$0] }.forEach(viewContext.delete)

            do  {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func getCalorie() -> Float{
        var sum:Float = 0
        for record in foodRecords{
            sum += record.calorieGained
        }
        return sum
    }
    var body: some View {
        ZStack {
            Text("Food Diary")
                .font(.title2)
                .bold()
            HStack {
                Spacer()
                if getCalorie()/2500 < 1 {
                    ZStack {
                        Circle()
                            .stroke(
                                Color(.gray).opacity(0.5),
                                lineWidth: 10
                            )
                            .frame(width: 50)
                        Circle()
                            .trim(from: 0, to: CGFloat(getCalorie()/2500))
                            .stroke(
                                AngularGradient(
                                    gradient: Gradient(
                                        colors: [.red, .yellow, .green]),
                                    center: .center
                                ),
                                style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        
                            .frame(width: 50)
                            .rotationEffect(.degrees(-90))
                    }
                }else{
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 45))
                        .foregroundColor(.green)
                }
            }
            .padding(.trailing, 20)
        }
        Divider()
        List{
            ForEach(foodRecords){ record in
                Button(action: {
                    selectedRecord = record
                }, label: {
                    FoodRecordView(foodRecord: record)
                })
                .foregroundColor(Color(.black))
                .padding(.horizontal, -10)
                .edgesIgnoringSafeArea(.all)
            }
            .onDelete(perform: deleteItems)
            
            Button(action: {
                selectedRecord = nil
                showAddSheet = true
            }, label: {
                AddNewRecordView()
            })
            .padding(.horizontal, -10)
            .frame(maxWidth: .infinity)
            .edgesIgnoringSafeArea(.all)
            .fullScreenCover(isPresented: $showAddSheet, content: {
                AddNewRecordDetailView()
            })
            
        }
        .listStyle(.plain)
        .sheet(item: $selectedRecord){ record in
            FoodRecordDetailView(foodRecord: record)
                .fixedSize(horizontal: false, vertical: true)
                .modifier(GetHeightModifier(height: $sheetHeight))
                .presentationDetents([.height(sheetHeight)])
        }
        CalendarView(dayStore: dayStore)
            .onChange(of: dayStore.currentDate) {
                foodRecords.nsPredicate = makeDatePredicate(currentDate: dayStore.currentDate)
            }
    }
}

#Preview {
    DietaryPlaningView()
//        .environmentObject(ModelData())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
