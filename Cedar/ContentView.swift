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

struct ContentView: View {
    @State var habits: [Habit] = [
        Habit(id: "1", title: "Workout", completions: [
            HabitCompletion(),
            HabitCompletion(date: Date(timeIntervalSinceNow: -(24 * 60 * 60 * 2))),
            HabitCompletion(date: Date(timeIntervalSinceNow: -(24 * 60 * 60 * 3))),
            HabitCompletion(date: Date(timeIntervalSinceNow: -(24 * 60 * 60 * 4)))
        ]),
        Habit(id: "2", title: "Drink 60 ounces of water"),
        Habit(id: "3", title: "Meditate")
    ]
    
    var body: some View {
        ZStack {
            ScrollView() {
                VStack {
                    Text("cedar")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.sRGB, white: 0.33, opacity: 1))
                    ForEach(habits) { habit in
                        HabitRowView(habit: habit)
                    }
                }
                .padding(.top, 16)
            }
            VStack {
                Spacer()
                AddButton()
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

struct HabitRowView: View {
    @State var habit: Habit
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(8)
                .shadow(color: Color(.sRGB, white: 0, opacity: 0.1), radius: 10)
            VStack {
                HStack {
                    Text(habit.title)
                        .font(.headline)
                        .foregroundColor(Color(.sRGB, white: 0.33, opacity: 1))
                    Spacer()
                    Button(action: {
                        if self.habit.isComplete {
                            self.habit.completions.remove(at: 0)
                        } else {
                            self.habit.completions.insert(HabitCompletion(), at: 0)
                        }
                    }) {
                        ZStack {
                            Circle()
                                .foregroundColor(habit.isComplete ? Color.green : Color(.sRGB, white: 0, opacity: 0.10))
                                .frame(width: 44, height: 44)
                            Image(systemName: "checkmark")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                }
                HStack {
                    Spacer()
                    HStack {
                        ForEach(0..<5) { idx in
                            Circle()
                                .foregroundColor(self.habit.wasCompleted(daysAgo: 4 - idx) ? Color.green : Color(.sRGB, white: 0, opacity: 0.10))
                                .frame(width: 6, height: 6)
                        }
                    }
                }
            }
            .padding()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

struct AddButton: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.white)
                .frame(width: 72, height: 72)
                .shadow(color: Color(.sRGB, white: 0, opacity: 0.08), radius: 30)
            
            Image(systemName: "plus")
                .font(.largeTitle)
//                .background(LinearGradient(gradient: Gradient(colors: [.red, .orange, .yellow]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .foregroundColor(Color(.sRGB, white: 0.33, opacity: 1))
        }
    }
}
