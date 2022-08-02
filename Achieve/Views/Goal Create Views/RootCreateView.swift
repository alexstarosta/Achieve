//
//  RootCreateView.swift
//  Achieve
//
//  Created by swift on 2022-07-24.
//

import SwiftUI

class newGoalInfo: ObservableObject {
    
    @Published var title: String = ""
    @Published var displayTitle: String = ""
    @Published var catagory: GoalCatagory?
    @Published var directionIndex: Int = -1
    @Published var goalSpecs = GoalSpecs()
    
    @Published var selectedPicker = 1
    
    @Published var accentColor = Color.black
    @Published var backgroundColor = Color.gray
    
    @Published var isDeleted = false
    @Published var isCompleted = false
    @Published var isDoneForToday = false
    @Published var isGone = false
    
    @Published var startingNum = 0
    @Published var timesCompleted = 0
    
    @Published var currentlyCustom = true
    @Published var showRepeatError = false
    
    @Published var greyOut = false
    @Published var directionsForUser: [String]?
}

struct RootCreateView: View {
    
    @StateObject var goalInfo = newGoalInfo()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                TitleCreateView()
            }
                .navigationBarItems(trailing:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                })
        }
        .environmentObject(goalInfo)
        
    }
}

struct RootCreateView_Previews: PreviewProvider {
    static var previews: some View {
        RootCreateView()
    }
}
