//
//  UserInfo.swift
//  Achieve
//
//  Created by swift on 2022-08-10.
//

import Foundation

// DATA STORED IN FIREBASE DATABASE
class UserData : ObservableObject {
    
    // ARRAYS OF GOALS
    @Published var activeGoalsArray: [Goal] = []
    @Published var completedForToday: [Goal] = []
    @Published var deletedGoalsArray: [Goal] = []
    @Published var completedGoalsArray: [Goal] = []
    
    // GLOBAL REFRESH SETTING
    @Published var refresh = true
    
    // PROGRESSION BAR
    @Published var progressionEnd: Double = 0
    @Published var progressionStart: Double = 0
    @Published var catagoryScores: [Double] = []
    
    func updateOverall (){
        self.progressionEnd = currentProgressTotal(self.activeGoalsArray)
        self.progressionStart = currentProgressStart(self.activeGoalsArray)
        self.catagoryScores = catagoryPrecedence(self.activeGoalsArray)
        self.refresh.toggle()
    }
    
}

// DATA STORED ON USER DEVICE
class LocalUserData : ObservableObject {
    
    // SHOWS USER FIRST TIME CREATE BUTTON
    @Published var firstTime = true
    
    // SHOWS USER THE WELCOME SCREEN
    @Published var showWelcomeScreen = false
    
    // USER SETTINGS BASED ON LOCAL PREFRENCES
    @Published var disableCompletion = false
    @Published var darkMode = false
    @Published var notificationBool = false
    @Published var notificationTime = Date()
    
    // BASIC GOAL COMPLETION INFO
    @Published var showingGoalCompleted = false
    @Published var latestCompleteInfo = Goal()
    @Published var latestCompleteTextType = 0
}
