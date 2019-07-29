import Combine
import CoreData
import SwiftUI

struct HabitViewModel: Identifiable {
    let id: NSManagedObjectID
    
    let title: String
    let isComplete: Bool
    
    init?(habit: Habit) {
        guard let title = habit.title else { return nil }
        let completions = habit.completions
        self.id = habit.objectID
        self.title = title
        self.isComplete = true
    }
}

final class HabitsStore: NSObject, BindableObject, NSFetchedResultsControllerDelegate {
    var willChange = PassthroughSubject<Void, Never>()
    
    var habits: [HabitViewModel] {
        let habits = fetchedResultsController.fetchedObjects ?? []
        let viewModels = habits.compactMap(HabitViewModel.init)
        return viewModels
    }
    
    func createHabit(with title: String) {
        persistentContainer.performBackgroundTask { (context) in
            let habit = Habit(context: context)
            habit.title = title
            habit.createdAt = Date()
            
            do {
                try context.save()
            } catch {
                print("Error saving habit", error)
            }
        }
    }
    
    func complete(habitWithId habitId: NSManagedObjectID) {
        persistentContainer.performBackgroundTask { (context) in
            let completion = HabitCompletion(context: context)
            completion.date = Date()
            
            let habit = context.object(with: habitId) as! Habit
            habit.addToCompletions(completion)
            
            do {
                try context.save()
            } catch {
                print("Error saving completion", error)
            }
        }
    }
    
    override init() {
        super.init()
        
        try? self.fetchedResultsController.performFetch()
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<Habit> = {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        willChange.send(())
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
        container.viewContext.automaticallyMergesChangesFromParent = true
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
