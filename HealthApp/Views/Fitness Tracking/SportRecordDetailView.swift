//
//  SportRecordDetailView.swift
//  HealthApp
//
//  Created by Chan King Yeung on 11/19/23.
//

import SwiftUI

struct SportRecordDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    var record: SportsRecord?
    @State var name: String
    @State var time: Date
    @State var place: String
    @State var finished: Bool
    @State var selectedSportsArray: [Sport]
    @State var showActivitySheet = false
    @State var selectedSport: Sport? = nil

    var threeColumnGrid = [GridItem(.flexible()),
                           GridItem(.flexible()),
                           GridItem(.flexible())]
    
    init(record: SportsRecord?) {
        if let r = record {
            self.record = record
            _time = State(initialValue: r.date!)
            _place = State(initialValue: r.venue!)
            _name = State(initialValue: r.name!)
            _finished = State(initialValue: r.finished)
            _selectedSportsArray = State(initialValue: Array(r.sports! as! Set<Sport>))
        } else {
            self.record = nil
            _time = State(initialValue: Date())
            _place = State(initialValue: "")
            _name = State(initialValue: "")
            _finished = State(initialValue: false)
            _selectedSportsArray = State(initialValue: [])
        }
    }
    
    var body: some View {
        VStack {
            Form {
                LabeledContent {
                    TextField("", text: $name)
                        .multilineTextAlignment(.trailing)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                } label: {
                    Text("Name")
                }
                DatePicker("Time", selection: $time)
                LabeledContent {
                    TextField("", text: $place)
                        .multilineTextAlignment(.trailing)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                } label: {
                    Text("Place")
                }
                Toggle("Finished", isOn: $finished)
            }
                .frame(maxHeight: 250)
                .scrollDisabled(true)
            VStack {
                LazyVGrid(columns: threeColumnGrid, spacing: 40) {
                    ForEach(selectedSportsArray) { sport in
                        Button(action: {
                            selectedSport = sport
                        }, label: {
                            VStack {
                                Image(sport.name!)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(.circle)
                                    .background(Circle().fill(.white).shadow(color: Color.black.opacity(0.5), radius: 6, x: 0, y: 3))
                                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                                    .padding(.horizontal, 5)
                                Text(sport.set != 0 ? String(sport.set): String(sport.duration) + " min")
                                    .foregroundColor(.black)
                            }
                        })
                    }
                    Button(action: {
                        showActivitySheet = true
                    }, label: {
                        VStack {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                        }
                        .padding(.bottom, 25)
                    })
                }
                Button("Submit"){
                    submitRecord()
                    dismiss()
                }
                .disabled(name == "" || place == "" || selectedSportsArray.isEmpty)
                .padding()
                .foregroundColor(.white)
                .background(name == "" || place == "" || selectedSportsArray.isEmpty ? Color.gray : Color.blue)
                .cornerRadius(40)
                .padding()
            }
            .padding(.horizontal)
            .background(Color(red: 0.949, green: 0.949, blue: 0.969))
            .padding(.top, -8)
            .listRowBackground(Color.clear)
            .sheet(item: $selectedSport, content: { selectedSport in
                ChooseSportView(selectedSportsArray: $selectedSportsArray, selectedSport: selectedSport)
                    .environmentObject(modelData)
            })
            .sheet(isPresented: $showActivitySheet, content: {
                ChooseSportView(selectedSportsArray: $selectedSportsArray, selectedSport: nil)
                    .environmentObject(modelData)
            })
        }
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding()
        .background(Color.black)
    }
        
    private func submitRecord() {
        if let r = record {
            r.date = time
            r.name = name
            r.venue = place
            r.finished = finished
            let newSet = NSSet().addingObjects(from: selectedSportsArray)
            r.sports = newSet as NSSet
        } else {
            let r = SportsRecord(context: viewContext)
            r.date = time
            r.name = name
            r.venue = place
            r.finished = finished
            let newSet = NSSet().addingObjects(from: selectedSportsArray)
            r.sports = newSet as NSSet
            r.id = UUID()
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
}

var test: SportsRecord? = nil

#Preview {
    SportRecordDetailView(record: nil)
}

