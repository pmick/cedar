import Combine
//import CoreData
import SwiftUI

struct HabitListView: View {
    @ObservedObject var habitsStore = HabitsStore()

    var body: some View {
        ZStack {
            ScrollView() {
                VStack {
                    Text("cedar")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    ForEach(habitsStore.habits) { habit in
                        HabitRowView(habitsStore: self.habitsStore, habit: habit)
                    }
                }
                .padding(.top, 16)
            }
            VStack {
                Spacer()
                AddButton(habitsStore: habitsStore)
            }
        }
    }
}

#if DEBUG
struct HabitListView_Previews: PreviewProvider {
    static var previews: some View {
        HabitListView()
    }
}
#endif

struct HabitRowView: View {
    let habitsStore: HabitsStore
    let habit: HabitViewModel
    @State var isPresented = false
    
    var body: some View {
        Button(action: {
            self.isPresented.toggle()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .foregroundColor(.white)
                    .shadow(color: Color(.sRGB, white: 0, opacity: 0.1), radius: 10)
                VStack {
                    HStack {
                        Text(habit.title)
                            .font(.headline)
                            .foregroundColor(Color(.sRGB, white: 0.33, opacity: 1))
                        Spacer()
                        Button(action: {
                            self.habitsStore.complete(habitWithId: self.habit.id)
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
                                    .foregroundColor(self.habit.completionDaysAgo.contains(4 - idx) ? Color.green : Color(.sRGB, white: 0, opacity: 0.10))
                                    .frame(width: 6, height: 6)
                            }
                        }
                    }
                }
                .padding()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }.sheet(isPresented: $isPresented) {
            HabitDetailView(habitsStore: self.habitsStore, habitViewModel: self.habit) { self.isPresented.toggle() }
        }
    }
}

struct AddButton: View {
    let habitsStore: HabitsStore
    @State var isPresented = false

    var body: some View {
        Button(action: {
            self.isPresented.toggle()
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
        }.sheet(isPresented: $isPresented) {
            return NewHabitView(habitsStore: self.habitsStore, isPresented: self.$isPresented)
        }
    }
}
