import Foundation
import SwiftUI

struct Habit: Identifiable {
    let id = UUID()
    let title: String
    var completions: [HabitCompletion] = []
}

struct HabitCompletion: Identifiable {
    let id = UUID()
    var date = Date()
}
