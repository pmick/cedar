import SwiftUI

struct ContentView: View {
    @State var habits: [Habit] = [
        Habit(title: "Workout", completions: [
            HabitCompletion(),
            HabitCompletion(date: Date(timeIntervalSinceNow: -(24 * 60 * 60 * 2))),
            HabitCompletion(date: Date(timeIntervalSinceNow: -(24 * 60 * 60 * 3))),
            HabitCompletion(date: Date(timeIntervalSinceNow: -(24 * 60 * 60 * 4)))
        ]),
        Habit(title: "Drink 60 ounces of water"),
        Habit(title: "Meditate")
    ]
    
    var body: some View {
        ZStack {
            ScrollView() {
                VStack {
                    Text("cedar")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
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
    private let habitController = HabitController()
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
                        if self.habitController.isComplete(habit: self.habit) {
                            self.habit.completions.remove(at: 0)
                        } else {
                            self.habit.completions.insert(HabitCompletion(), at: 0)
                        }
                    }) {
                        ZStack {
                            Circle()
                                .foregroundColor(habitController.isComplete(habit: habit) ? Color.green : Color(.sRGB, white: 0, opacity: 0.10))
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
                                .foregroundColor(self.habitController.wasCompleted(daysAgo: 4 - idx, habit: self.habit) ? Color.green : Color(.sRGB, white: 0, opacity: 0.10))
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
    @State var shown = false

    var body: some View {
        Button(action: {
            self.shown.toggle()
        }) {
            ZStack {
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 72, height: 72)
                    .shadow(color: Color(.sRGB, white: 0, opacity: 0.08), radius: 30)
                
                Image(systemName: "plus")
                    .font(.largeTitle)
                    .foregroundColor(.green)
            }
        }.sheet(isPresented: $shown) {
            return NewHabitView()
        }
    }
}
