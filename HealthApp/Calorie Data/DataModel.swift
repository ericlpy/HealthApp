//
//  DataModel.swift
//  HealthApp
//
//  Created by Eric Li on 17/11/2023.
//

import Foundation

class ModelData: ObservableObject{
    @Published var calorieDataTable:[CalorieDataTable] = Array()
    
    init() {
        let pathString = Bundle.main.path(forResource: "CalorieData", ofType: "json")
        if let path = pathString {
            let url = URL(filePath: path)
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                do {
                    let dataTable = try decoder.decode([CalorieDataTable].self, from: data)
                    self.calorieDataTable = dataTable
                }catch{
                    print(error)
                }
            }catch{
                print(error)
            }
        }
    }
}
