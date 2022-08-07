//
//  ContentView.swift
//  Achieve
//
//  Created by swift on 2022-07-22.
//

import SwiftUI

class goalScreenInfo : ObservableObject {
    
    @Published var activeGoalsArray: [Goal] = []
    @Published var completedForToday: [Goal] = []
    @Published var deletedGoalsArray: [Goal] = []
    @Published var completedGoalsArray: [Goal] = []
    @Published var firstTime = true
    @Published var showWelcomeScreen = false
    @Published var refresh = true
    
    @Published var progressionEnd: Double = 0
    @Published var progressionStart: Double = 0
    @Published var catagoryScores: [Double] = []
    
    @Published var disableCompletion = false
    @Published var darkMode = false
    @Published var notificationBool = false
    @Published var notificationTime = Date()
    
    @Published var showingGoalCompleted = false
    @Published var latestCompleteInfo = Goal()
    @Published var latestCompleteTextType = 0
    
    func updateOverall (){
        self.progressionEnd = currentProgressTotal(self.activeGoalsArray)
        self.progressionStart = currentProgressStart(self.activeGoalsArray)
        self.catagoryScores = catagoryPrecedence(self.activeGoalsArray)
        self.refresh.toggle()
    }
    
}

struct ContentView: View {
    @StateObject var screenInfo = goalScreenInfo()
    var body: some View {
        TabView {
            GoalsView()
                .tabItem{
                    Image(systemName: "flag")
                    Text("Goals")
                }
            
            AchievementsView()
                .tabItem{
                    Image("achieveIconBlankBlack")
                    Text("Achievements")
                }
            
            SettingsView()
                .tabItem{
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
        .environmentObject(screenInfo)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
