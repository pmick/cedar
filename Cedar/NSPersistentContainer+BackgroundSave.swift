import CoreData

extension NSPersistentContainer {
    func performBackgroundTaskAndSave(_ closure: @escaping (NSManagedObjectContext) -> Void) {
        performBackgroundTask { context in
            closure(context)
            
            do {
                try context.save()
            } catch {
                print("Error saving habit", error)
            }
        }
    }
}
