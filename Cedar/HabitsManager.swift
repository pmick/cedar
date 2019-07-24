import Combine
import SwiftUI

final class HabitsManager: BindableObject {
    var willChange = PassthroughSubject<Void, Never>()
    
    var habits: [Habit] = [
        Habit(title: "Workout", completions: [
            HabitCompletion(),
            HabitCompletion(date: Date(timeIntervalSinceNow: -(24 * 60 * 60 * 2))),
            HabitCompletion(date: Date(timeIntervalSinceNow: -(24 * 60 * 60 * 3))),
            HabitCompletion(date: Date(timeIntervalSinceNow: -(24 * 60 * 60 * 4)))
        ]),
        Habit(title: "Drink 60 ounces of water"),
        Habit(title: "Meditate")
        ] {
        willSet {
            willChange.send(())
        }
    }
}
