import SwiftUI

struct HabitRowView: View {
    let habitsStore: HabitsStore
    let habit: HabitViewModel
    @State var isPresented = false
    
    var body: some View {
        Button(action: {
            self.isPresented.toggle()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .circular)
                    .foregroundColor(.white)
                    .shadow(color: Color(.sRGB, white: 0, opacity: 0.05), radius: 8, x: 0, y: 8)
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(habit.title)
                                .font(.headline)
                                .foregroundColor(Color(.sRGB, white: 0.33, opacity: 1))
                            Text(habit.reason)
                                .font(.subheadline)
                                .foregroundColor(Color(.sRGB, white: 0.66, opacity: 1))
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Button(action: {
                                self.habitsStore.complete(habitWithId: self.habit.id)
                            }) {
                                ZStack {
                                    Circle()
                                        .foregroundColor(habit.isComplete ? Color.cedarGreen : Color(.sRGB, white: 0, opacity: 0.10))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: "checkmark")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                            }
                            Spacer()
                            HStack {
                                ForEach(0..<5) { idx in
                                    Circle()
                                        .foregroundColor(self.habit.completionDaysAgo.contains(4 - idx) ? Color.cedarGreen : Color(.sRGB, white: 0, opacity: 0.10))
                                        .frame(width: 6, height: 6)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 8)
        }.sheet(isPresented: $isPresented) {
            HabitDetailView(habitsStore: self.habitsStore, habitViewModel: self.habit) { self.isPresented.toggle() }
        }
    }
}

#if DEBUG
struct HabitRowView_Previews: PreviewProvider {
    static var previews: some View {
        HabitRowView(habitsStore: HabitsStore(), habit: .test)
            .frame(height: 100)
    }
}
#endif
