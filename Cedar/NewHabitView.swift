import SwiftUI

struct NewHabitView: View {
    let habitsStore: HabitsStore

    @Binding var shown: Bool
    
    @State var title: String = ""
    @State var why: String = ""
    
    var isFormComplete: Bool {
        return !title.isEmpty && !why.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack {
                EntryFieldView(title: "Title", binding: $title)
                EntryFieldView(title: "Why", binding: $why)
                Spacer()
            }
            .padding()
            .navigationBarTitle("Add Habit")
            .navigationBarItems(
                leading:
                Button(action: {
                    self.shown = false
                }, label: {
                    Text("Cancel")
                        .foregroundColor(.green)
                }),
                trailing:
                Button(action: {
                    self.habitsStore.createHabit(with: self.title)
                    self.shown = false
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
        NewHabitView(habitsStore: HabitsStore(), shown: Binding<Bool>(getValue: { return true }, setValue: { _ in }))
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
