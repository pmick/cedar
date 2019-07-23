//
//  NewHabitView.swift
//  Cedar
//
//  Created by Patrick Mick on 7/21/19.
//  Copyright © 2019 Patrick Mick. All rights reserved.
//

import SwiftUI

struct NewHabitView: View {
    @State var title: String = ""
    @State var why: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Title")
                        .fontWeight(.bold)
                    TextField("Title", text: $title)
                }
                HStack {
                    Text("Why")
                        .fontWeight(.bold)
                    TextField("Why", text: $why)
                }
                Spacer()
            }
            .padding()
            .navigationBarTitle("Add Habit")
            .navigationBarItems(
                leading:
                Button(action: {
                    print("Cancel tapped")
                }, label: {
                    Text("Cancel")
                        .foregroundColor(.green)
                }),
                trailing:
                Button(action: {
                    print("Add tapped")
                }, label: {
                    Text("Add")
                        .foregroundColor(.green)
                        .fontWeight(.bold)
                })
            )
        }
    }
}

#if DEBUG
struct NewHabitView_Previews: PreviewProvider {
    static var previews: some View {
        NewHabitView()
    }
}
#endif
