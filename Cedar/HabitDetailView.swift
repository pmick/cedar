import CoreData
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
                    .fontWeight(.bold)
                    .foregroundColor(.cedarGreen)
            }))
        }
    }
}

#if DEBUG
extension HabitViewModel {
    static var test: HabitViewModel {
        return HabitViewModel(id: NSManagedObjectID(), title: "Workout", reason: "Build confidence", isComplete: true, completionDaysAgo: Set())
    }
}

struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailView(habitsStore: HabitsStore(), habitViewModel: .test, onClose: { })
    }
}
#endif
