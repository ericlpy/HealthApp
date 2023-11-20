//
//  FoodRecord.swift
//  HealthApp
//
//  Created by Eric Li on 17/11/2023.
//

import Foundation

struct RecordOfFood: Identifiable {
    var id: Int
    var foods: String
    var meal: String
    var amount: Int16
    var calorieGained: Int16
    var date: Date
}
