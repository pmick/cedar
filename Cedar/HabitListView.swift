import Combine
//import CoreData
import SwiftUI

struct HabitListView: View {
    @ObservedObject var habitsStore = HabitsStore()
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(hue: 0.72, saturation: 0.02, brightness: 0.98))
                .edgesIgnoringSafeArea(.all)
            ScrollView() {
                VStack {
                    Text("cedar")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.cedarGreen)
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

struct AddButton: View {
    let habitsStore: HabitsStore
    @State var isPresented = false
    
    var body: some View {
        Button(action: {
            self.isPresented.toggle()
        }) {
            ZStack {
                Circle()
                    .foregroundColor(.cedarGreen)
                    .frame(width: 64, height: 64)
                
                Image(systemName: "plus")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
        }.sheet(isPresented: $isPresented) {
            return NewHabitView(habitsStore: self.habitsStore, isPresented: self.$isPresented)
        }.accessibility(label: Text("Add New Habit"))
    }
}
