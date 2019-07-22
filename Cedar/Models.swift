import Foundation
import SwiftUI

struct Habit: Identifiable {
    let id: String
    let title: String
    var completions: [HabitCompletion] = []
}

struct HabitCompletion: Identifiable {
    let id: UUID = UUID()
    var date = Date()
}

