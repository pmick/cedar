import SwiftUI

struct NewHabitView: View {
    let habitsStore: HabitsStore

    @Binding var isPresented: Bool
    
    @State var title: String = ""
    @State var reason: String = ""
    
    var isFormComplete: Bool {
        return !title.isEmpty && !reason.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack {
                EntryFieldView(title: "Title", binding: $title)
                EntryFieldView(title: "Reason", binding: $reason)
                Spacer()
            }
            .padding()
            .navigationBarTitle("Add Habit")
            .navigationBarItems(
                leading:
                Button(action: {
                    self.isPresented = false
                }, label: {
                    Text("Cancel")
                        .foregroundColor(.cedarGreen)
                }),
                trailing:
                Button(action: {
                    self.habitsStore.createHabit(with: self.title, reason: self.reason)
                    self.isPresented = false
                }, label: {
                    Text("Add")
                        .foregroundColor(isFormComplete ? Color.cedarGreen : Color.cedarGreen.opacity(0.3))
                        .fontWeight(.bold)
                }).disabled(!isFormComplete)
            )
        }
    }
}

#if DEBUG
struct NewHabitView_Previews: PreviewProvider {
    static var previews: some View {
        NewHabitView(habitsStore: HabitsStore(), isPresented: Binding(get: { return true }, set: { _ in }))
    }
}
#endif

struct EntryFieldView: View {
    let title: String
    @Binding var binding: String
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.bold)
                .baselineOffset(2.0)
            TextField(title, text: $binding)
        }
    }
}
