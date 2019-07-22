import Foundation

final class HabitController {
    func isComplete(habit: Habit) -> Bool {
        guard let lastCompletionDate = habit.completions.first?.date else { return false }
        return Calendar.current.isDateInToday(lastCompletionDate)
    }
    
    func wasCompleted(daysAgo: Int, habit: Habit) -> Bool {
        let calendar = Calendar.current
        guard let day = calendar.date(byAdding: .day, value: -daysAgo, to: Date(), wrappingComponents: false) else { return false }
        let completion = habit.completions.first { completion -> Bool in
            let result = calendar.compare(completion.date, to: day, toGranularity: .day)
            return result == .orderedSame
        }
        return completion != nil
    }
}
