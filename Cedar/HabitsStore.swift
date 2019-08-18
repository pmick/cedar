import Combine
import CoreData
import SwiftUI

final class HabitsStore: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    var objectWillChange = PassthroughSubject<Void, Never>()
    private lazy var habitMutationQueue: OperationQueue = .serial
    
    var habits: [HabitViewModel] {
        let habits = fetchedResultsController.fetchedObjects ?? []
        let viewModels = habits.compactMap(HabitViewModel.init)
        return viewModels
    }
    
    override init() {
        super.init()
        
        try? self.fetchedResultsController.performFetch()
    }
    
    func createHabit(with title: String, reason: String) {
        assert(!title.isEmpty)
        assert(!reason.isEmpty)
        
        persistentContainer.performBackgroundTaskAndSave { context in
            let habit = Habit(context: context)
            habit.title = title
            habit.reason = reason
            habit.createdAt = Date()
        }
    }

    func deleteHabit(with id: NSManagedObjectID) {
        persistentContainer.performBackgroundTaskAndSave { context in
            let habit = context.object(with: id)
            context.delete(habit)
        }
    }

    func complete(habitWithId habitId: NSManagedObjectID) {
        let operation = ToggleHabitCompleteOperation(persistentContainer: persistentContainer, habitId: habitId)
        habitMutationQueue.addOperation(operation)
    }

    // MARK: - NSFetchedResultsControllerDelegate

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        objectWillChange.send(())
    }

    // MARK: - Core Data stack

    private lazy var persistentContainer: NSPersistentCloudKitContainer = {
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

    private lazy var fetchedResultsController: NSFetchedResultsController<Habit> = {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
}
