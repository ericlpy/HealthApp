//
//  HealthDataManagementView.swift
//  HealthApp
//
//  Created by on 14/11/2023.
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
                    ForEach(records.indices, id: \.self) { index in
                        Button(action: {
                            selectedItem = records[index]
                        }, label: {
                            if (!records[index].isDeleted) {
                                FoodSelectionRow(record: records[index])
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


#Preview {
    HealthDataManagementView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
