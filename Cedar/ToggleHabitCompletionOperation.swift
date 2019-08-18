import CoreData

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
