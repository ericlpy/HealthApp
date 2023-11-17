//
//  CalorieDataTable.swift
//  HealthApp
//
//  Created by Eric Li on 17/11/2023.
//

import Foundation
struct CalorieDataTable: Identifiable, Decodable {
    var id: Int
    var name: String
    var type: String
    var calories: Float
}
