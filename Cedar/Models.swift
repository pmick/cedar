import Foundation
import SwiftUI

struct Habit: Identifiable {
    let id: String
    let title: String
    var completions: [HabitCompletion] = []
    
    var isComplete: Bool {
        guard let lastCompletionDate = completions.first?.date else { return false }
        return Calendar.current.isDateInToday(lastCompletionDate)
    }
    
    func wasCompleted(daysAgo: Int) -> Bool {
        let calendar = Calendar.current
        guard let day = calendar.date(byAdding: .day, value: -daysAgo, to: Date(), wrappingComponents: false) else { return false }
        let completion = completions.first { completion -> Bool in
            let result = calendar.compare(completion.date, to: day, toGranularity: .day)
            return result == .orderedSame
        }
        return completion != nil
    }
}

struct HabitCompletion: Identifiable {
    let id: UUID = UUID()
    var date = Date()
}

