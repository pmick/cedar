import Combine
import CoreData
import SwiftUI
//
//final class HabitsStore {
//    func writeToDisk(_ habits: [Habit]) {
//        do {
//            let data = try JSONEncoder().encode(habits)
//            let fileManager = FileManager.default
//            let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//            let fileUrl = documentsUrl.appendingPathComponent("habits.json")
//            
//            try data.write(to: fileUrl)
//        } catch {
//            print("error writing habits to disk")
//        }
//    }
//    
//    func readHabits() -> [Habit] {
//        do {
//            let fileManager = FileManager.default
//            let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//            let fileUrl = documentsUrl.appendingPathComponent("habits.json")
//            let data = try Data(contentsOf: fileUrl)
//            let decoded = try JSONDecoder().decode([Habit].self, from: data)
//            return decoded
//        } catch {
//            print("error reading", error)
//            return []
//        }
//    }
//}
//
//final class HabitsManager: BindableObject {
//    private let store = HabitsStore()
//    
//    var willChange = PassthroughSubject<Void, Never>()
//    
//    // init read from disk
//    
//    var habits: [Habit] = [
//        Habit(title: "Workout", completions: [
//            HabitCompletion(),
//            HabitCompletion(date: Date(timeIntervalSinceNow: -(24 * 60 * 60 * 2))),
//            HabitCompletion(date: Date(timeIntervalSinceNow: -(24 * 60 * 60 * 3))),
//            HabitCompletion(date: Date(timeIntervalSinceNow: -(24 * 60 * 60 * 4)))
//        ]),
//        Habit(title: "Drink 60 ounces of water"),
//        Habit(title: "Meditate")
//        ] {
//        willSet {
//            willChange.send(())
//        }
//        didSet {
//            store.writeToDisk(habits)
//            // write to disk?
//        }
//    }
//    
//    func complete(_ habit: Habit) {
//        var copy = habits
//    }
//    
//    func uncomplete(_ habit: Habit) {
//        
//    }
//}

final class HabitsStore: BindableObject {
    var willChange = PassthroughSubject<Void, Never>()
    
    var habits: [Habit] {
        do {
            let request: NSFetchRequest<Habit> = Habit.fetchRequest()
            let result = try persistentContainer.viewContext.fetch(request)
            return result
        } catch {
            print("Error fetching habits", error)
            return []
        }
    }
    
    func createHabit(with title: String) {
        persistentContainer.performBackgroundTask { (context) in
            let habit = Habit(context: context)
            habit.title = title
            
            do {
                try context.save()
            } catch {
                print("Error saving habit", error)
            }
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Cedar")
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
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
