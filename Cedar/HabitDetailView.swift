import SwiftUI

struct HabitDetailView: View {
    let habitsStore: HabitsStore
    let habitViewModel: HabitViewModel
    let onClose: () -> Void
    
    var body: some View {
        NavigationView {
            Button(action: {
                self.habitsStore.deleteHabit(with: self.habitViewModel.id)
                self.onClose()
            }) {
                Text("Delete")
                    .fontWeight(.bold)
                    .foregroundColor(Color.red)
            }
            .navigationBarTitle(habitViewModel.title)
            .navigationBarItems(trailing: Button(action: {
                self.onClose()
            }, label: {
                Text("Close")
            }))
        }
    }
}

#if DEBUG
extension HabitViewModel {
    static var test: HabitViewModel {
        let habit = Habit()
        habit.title = "Workout"
        return HabitViewModel(habit: habit)!
    }
}

struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailView(habitsStore: HabitsStore(), habitViewModel: .test, onClose: { })
    }
}
#endif
