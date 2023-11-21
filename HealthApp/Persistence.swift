//
//  Persistence.swift
//  HealthApp
//
//  Created by Eric Li on 12/11/2023.
//

import CoreData

let sport = ["weightLifting", "pullDowning", "benchPressing"]
let name = ["Testing 1", "Testing 2", "Testing 3", "Testing 4"]
let venue = ["Home", "Gym", "Sport Center"]

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        
        let viewContext = result.container.viewContext
        
//        creating sample data
        let newItem = FoodRecord(context: viewContext)
        let food1 = Food(context: viewContext)
        let food2 = Food(context: viewContext)
        food1.name = "cola"
        food2.name = "friedRice"
        newItem.calorieGained = 100
        newItem.date = Date()
        newItem.id = UUID()
        newItem.meal = "lunch"
        newItem.food = NSSet(array: [food1, food2])
        
        let newItem2 = FoodRecord(context: viewContext)
        let food3 = Food(context: viewContext)
        let food4 = Food(context: viewContext)
        food3.name = "cola"
        food4.name = "friedRice"
        newItem2.calorieGained = 150
        newItem2.date = Date()
        newItem2.id = UUID()
        newItem2.meal = "dinner"
        newItem2.food = NSSet(array: [food3, food4])
        
        for _ in 0..<4 {
            let newRecord = SportsRecord(context: viewContext)
            let sport1 = Sport(context: viewContext)
            let sport2 = Sport(context: viewContext)
            var tmp = sport.randomElement()
            sport1.name = tmp
            sport1.image = tmp
            
            tmp = sport.randomElement()
            sport2.name = tmp
            sport2.image = tmp
            
            sport1.calorieBurned = Float.random(in: 1..<200)
            sport1.set = Int16(Int.random(in: 1..<20))
            sport2.calorieBurned = Float.random(in: 1..<200)
            sport2.duration = Int16(Int.random(in: 1..<600))
            
            newRecord.id = UUID()
            newRecord.name = name.randomElement()
            var d = Date()
            d.addTimeInterval(Double.random(in: 60*10...60*60*12))
            newRecord.date = d
            newRecord.finished = false
            newRecord.venue = venue.randomElement()
            newRecord.sports = NSSet(array: [sport1, sport2])
        }
        
        for _ in 0..<4 {
            let newRecord = SportsRecord(context: viewContext)
            let sport1 = Sport(context: viewContext)
            let sport2 = Sport(context: viewContext)
            var tmp = sport.randomElement()
            sport1.name = tmp
            sport1.image = tmp
            
            tmp = sport.randomElement()
            sport2.name = tmp
            sport2.image = tmp
            
            sport1.calorieBurned = Float.random(in: 1..<200)
            sport1.set = Int16(Int.random(in: 1..<20))
            sport2.calorieBurned = Float.random(in: 1..<200)
            sport2.duration = Int16(Int.random(in: 1..<600))
            
            newRecord.id = UUID()
            newRecord.name = "Next Day"
            var d = Date()
            d.addTimeInterval(Double.random(in: 60*10+86400...60*60*12+86400))
            newRecord.date = d
            newRecord.finished = false
            newRecord.venue = venue.randomElement()
            newRecord.sports = NSSet(array: [sport1, sport2])
        }
        
        for _ in 0..<4 {
            let newRecord = SportsRecord(context: viewContext)
            let sport1 = Sport(context: viewContext)
            let sport2 = Sport(context: viewContext)
            var tmp = sport.randomElement()
            sport1.name = tmp
            sport1.image = tmp
            
            tmp = sport.randomElement()
            sport2.name = tmp
            sport2.image = tmp
            
            sport1.calorieBurned = Float.random(in: 1..<200)
            sport1.set = Int16(Int.random(in: 1..<20))
            sport2.calorieBurned = Float.random(in: 1..<200)
            sport2.duration = Int16(Int.random(in: 1..<600))
            
            newRecord.id = UUID()
            newRecord.name = "YesterDay"
            var d = Date()
            d.addTimeInterval(-Double.random(in: 60*10+86400...60*60*12+86400))
            newRecord.date = d
            newRecord.finished = false
            newRecord.venue = venue.randomElement()
            newRecord.sports = NSSet(array: [sport1, sport2])
        }
        
        let userRecord = UserRecord(context: viewContext)
        userRecord.id = UUID()
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "HealthApp")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
