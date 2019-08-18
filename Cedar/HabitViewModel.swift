import CoreData
import SwiftUI

struct HabitViewModel: Identifiable {
    let id: NSManagedObjectID
    let title: String
    let reason: String
    let isComplete: Bool
    let completionDaysAgo: Set<Int>
    
    init?(habit: Habit) {
        guard let title = habit.title, let reason = habit.reason else { return nil }
        guard let completions = habit.completions?.allObjects as? [HabitCompletion] else { return nil }
        
        // This probably won't scale to many completions, but it works 🤷‍♂️
        let daysAgoSet = Set(completions.compactMap { completion -> Int? in
            return Date().interval(ofComponent: .day, fromDate: completion.date!)
        })
        
        self.init(id: habit.objectID, title: title, reason: reason, isComplete: daysAgoSet.contains(0), completionDaysAgo: daysAgoSet)
    }
    
    init(id: NSManagedObjectID, title: String, reason: String, isComplete: Bool, completionDaysAgo: Set<Int>) {
        self.id = id
        self.title = title
        self.reason = reason
        self.isComplete = isComplete
        self.completionDaysAgo = completionDaysAgo
    }
}
