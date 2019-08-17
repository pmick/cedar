import Combine
import CoreData
import SwiftUI

// from: https://stackoverflow.com/questions/40075850/swift-3-find-number-of-calendar-days-between-two-dates
extension Date {
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
}

struct HabitViewModel: Identifiable {
    let id: NSManagedObjectID
    let title: String
    let isComplete: Bool
    let completionDaysAgo: Set<Int>
    
    init?(habit: Habit) {
        guard let title = habit.title else { return nil }
        guard let completions = habit.completions?.allObjects as? [HabitCompletion] else { return nil }
        
        // This probably won't scale to many completions, but it works 🤷‍♂️
        let daysAgoSet = Set(completions.compactMap { completion -> Int? in
            return Date().interval(ofComponent: .day, fromDate: completion.date!)
        })
        
        self.isComplete = daysAgoSet.contains(0)
        self.completionDaysAgo = daysAgoSet
        self.id = habit.objectID
        self.title = title
    }
}

/// Subclasses should implement main, and not call super. Super will switch `state` to executing.
/// When you're finished with async work, switch the operation `state` to `.finished`.
/// Finally, when switching threads or between subtasks check if the operation is cancelled. If it is switch the state to `.finished` and return.
class AsyncOperation: Operation {
    enum State {
        case waiting
        case executing
        case finished
        
        var kvoKey: String? {
            switch self {
            case .executing: return "isExecuting"
            case .finished: return "isFinished"
            default: return nil
            }
        }
    }
    
    var state: State = .waiting {
        willSet {
            if let kvoKey = state.kvoKey { willChangeValue(forKey: kvoKey) }
            if let kvoKey = newValue.kvoKey { willChangeValue(forKey: kvoKey) }
        }
        didSet {
            if let kvoKey = oldValue.kvoKey { didChangeValue(forKey: kvoKey) }
            if let kvoKey = state.kvoKey { didChangeValue(forKey: kvoKey) }
        }
    }
    
    override var isAsynchronous: Bool { return true }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }
    
    override func start() {
        guard !isCancelled else { state = .finished; return }
        state = .executing
        main()
    }
}

final class ToggleHabitCompleteOperation: AsyncOperation {
    let persistentContainer: NSPersistentContainer
    let habitId: NSManagedObjectID
    
    init(persistentContainer: NSPersistentContainer, habitId: NSManagedObjectID) {
        self.persistentContainer = persistentContainer
        self.habitId = habitId
    }
    
    override func main() {
        persistentContainer.performBackgroundTask { context in
            guard !self.isCancelled else { self.state = .finished; return }
            guard let habit = context.object(with: self.habitId) as? Habit else { self.state = .finished; return }

            let startOfToday = Calendar.current.startOfDay(for: Date())
            let request: NSFetchRequest<HabitCompletion> = HabitCompletion.fetchRequest()
            request.predicate = NSPredicate(format: "habit == %@ && date > %@", habit, startOfToday as NSDate)
            
            if let result = try? context.fetch(request), result.count > 0 {
                for completion in result {
                    context.delete(completion)
                }
            } else {
                let completion = HabitCompletion(context: context)
                completion.date = Date()
                habit.addToCompletions(completion)
            }
            
            do {
                try context.save()
            } catch {
                print("Toggle habit completion save error", error)
            }
            
            self.state = .finished
        }
    }
}

final class HabitsStore: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    var objectWillChange = PassthroughSubject<Void, Never>()
    lazy var habitMutationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
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
    
    func deleteHabit(with id: NSManagedObjectID) {
        persistentContainer.performBackgroundTask { context in
            let habit = context.object(with: id)
            context.delete(habit)
            
            do {
                try context.save()
            } catch {
                print("Error saving habit", error)
            }
        }
    }
    
    func complete(habitWithId habitId: NSManagedObjectID) {
        let operation = ToggleHabitCompleteOperation(persistentContainer: persistentContainer, habitId: habitId)
        habitMutationQueue.addOperation(operation)
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
        objectWillChange.send(())
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
}
