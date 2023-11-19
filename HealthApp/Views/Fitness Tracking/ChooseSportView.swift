//
//  ChooseSportView.swift
//  HealthApp
//
//  Created by Chan King Yeung on 11/19/23.
//

import SwiftUI

struct ChooseSportView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var selectedSportsArray: [Sport]
    @State var selectedSport: Sport?
    @State var tmp_array: [Sport]?
    @State var number: Int
    @State var choice: String
    
    let choices = ["Set", "Duration"]
    
    var threeColumnGrid = [GridItem(.flexible()),
                           GridItem(.flexible()),
                           GridItem(.flexible())]
    
    @State var name = ""
    
    init(selectedSportsArray: Binding<[Sport]>, selectedSport: Sport?) {
        _selectedSportsArray = selectedSportsArray
        if let selectedSport {
            _name = State(initialValue: selectedSport.name!)
            _selectedSport = State(initialValue: selectedSport)
            if selectedSport.set != 0 {
                _number = State(initialValue: Int(selectedSport.set))
                _choice = State(initialValue: "Set")
            } else {
                _number = State(initialValue: Int(selectedSport.duration))
                _choice = State(initialValue: "Duration")
            }
            _tmp_array = State(initialValue: self.selectedSportsArray.filter({ String($0.name!) != String(selectedSport.name!) }))
        } else {
            _name = State(initialValue: "")
            _selectedSport = State(initialValue: nil)
            _number = State(initialValue: 1)
            _choice = State(initialValue: "Set")
            _tmp_array = State(initialValue: self.selectedSportsArray)
        }
    }
    
    var body: some View {
        let sportList = modelData.calorieDataTable.filter { $0.type == "sport"}
        
        Section {
            LazyVGrid(columns: threeColumnGrid) {
                ForEach(sportList, id: \.name) { item in
                    Button(action: {
                        name = item.name
                    }, label: {
                        Image(item.name)
                            .resizable()
                            .scaledToFit()
                            .clipShape(.circle)
                            .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    })
                    .disabled(tmp_array!.contains(where: { $0.name == item.name }) || name == item.name)
                    .overlay(Circle().fill(Color.gray.opacity(tmp_array!.contains(where: { $0.name == item.name }) || name == item.name ? 0.5 : 0)))
                    .overlay(Image(systemName: "checkmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .opacity(name == item.name ? 1.0 : 0.0))
                }
            }
        }
        Divider()
        ForEach(tmp_array!) { sport in
            Text(sport.name!)
        }
        Divider()
        
        
        if let selectedSport {
            Text(selectedSport.name!)
        } else {
            Text("No Record")
        }
        Section {
            LabeledContent {
                Picker("", selection: $number) {
                    ForEach(1...1000, id: \.self) {
                        Text("\($0)" + String(choice == "Set" ? "" : " min"))
                    }
                }
                .pickerStyle(.wheel)
            } label: {
                Picker("", selection: $choice) {
                    ForEach(choices, id: \.self) { item in
                        Text(item)
                    }
                }
            }
            .frame(height: 100)
        }
        
        Button("Select"){
            submitItem(calorie: sportList.first(where: {$0.name == name})!.calories)
            dismiss()
        }
        .disabled(name == "")
    }
    
    private func submitItem(calorie: Float) {
        let newSport = Sport(context: viewContext)
        newSport.image = name
        newSport.name = name
        if (choice == "Set") {
            newSport.set = Int16(number)
            newSport.calorieBurned = calorie * Float(number)
        } else {
            newSport.duration = Int16(number)
            newSport.calorieBurned = calorie * Float(number)
        }
        
        tmp_array!.append(newSport)
        selectedSportsArray = tmp_array!
    }
}



var modelData = ModelData()

