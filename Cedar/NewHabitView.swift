import SwiftUI

struct NewHabitView: View {
    let habitsStore: HabitsStore

    @Binding var isPresented: Bool
    
    @State var title: String = ""
    
    var isFormComplete: Bool {
        return !title.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack {
                EntryFieldView(title: "Title", binding: $title)
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
                        .foregroundColor(.green)
                }),
                trailing:
                Button(action: {
                    self.habitsStore.createHabit(with: self.title)
                    self.isPresented = false
                }, label: {
                    Text("Add")
                        .foregroundColor(isFormComplete ? Color.green : Color.green.opacity(0.3))
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
