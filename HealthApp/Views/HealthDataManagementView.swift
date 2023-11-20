//
//  HealthDataManagementView.swift
//  HealthApp
//
//  Created by Hui Chak Yan on 14/11/2023.
//

import SwiftUI

struct HealthDataManagementView: View {
    var body: some View {
        VStack {
            Text("Health Data Management")
                .font(.title2)
                .bold()
            Divider()
//            NavigationView {
                List {
                    ForEach(selections.indices, id: \.self) { index in
                        Button(action: {
                            selectedItem = selections[index]
                        }, label: {
                            if (!selections[index].isDeleted) {
                                FoodSelectionRow(selection: selections[index])
                                    .foregroundColor(.black)
                            }
                        })
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, -10)
                        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .swipeActions(edge: .leading) {	
                            Button {
                                finishSelection(selection: selections[index])
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
                    FoodSelectionDetailView(record: item)
                        .environmentObject(modelData)
//                        .presentationDetents([.large, .medium, .fraction(0.55)])
                })
                .sheet(isPresented: $showActivitySheet, content: {
                    FoodSelectionDetailView(record: nil)
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
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
//            print(offsets[0])
            offsets.map { selections[$0] }.forEach(viewContext.delete)

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

    private func finishSelection(selection: FoodSelection) {
        withAnimation {
            selection.finished = true
            
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
    HealthDataManagementView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
