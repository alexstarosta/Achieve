//
//  GoalStructure.swift
//  Achieve
//
//  Created by swift on 2022-08-05.
//

import Foundation
import SwiftUI

func getGoalIndex(from: [Goal], user: Goal) -> Int? {
    return from.firstIndex(where: { $0 === user })
}

class Goal: ObservableObject, Identifiable {
    
    @Published var title: String
    @Published var displayTitle: String
    
    @Published var catagory: GoalCatagory?
    
    @Published var directionIndex: Int
    
    @Published var goalInformation = GoalInformation()
    
    @Published var accentColor: Color
    @Published var backgroundColor: Color
    
    @Published var state: GoalState
    
    @Published var timesCompleted: Int
    
    @Published var extras = GoalExtras()
    
    @Published var goalID: UUID
    @Published var goalTimeID: Date
    
    init() {
        self.title = ""
        self.displayTitle = ""
        self.directionIndex = -1
        self.accentColor = Color.black
        self.backgroundColor = Color.gray
        self.state = .custom
        self.timesCompleted = 0
        self.goalID = UUID()
        self.goalTimeID = Date()
    }
    
    func deleteGoal (_ userData: goalScreenInfo,_ goal:Goal){
        withAnimation(.easeOut) {
            let oldState = goal.state
            goal.state = .deleted
            
            if oldState == .doneToday {
                let goalIndex = getGoalIndex(from: userData.completedForToday, user: goal)!
                userData.completedForToday.remove(at: goalIndex)
                userData.deletedGoalsArray.append(goal)
                userData.updateOverall()
            } else {
                let goalIndex = getGoalIndex(from: userData.activeGoalsArray, user: goal)!
                userData.activeGoalsArray.remove(at: goalIndex)
                userData.deletedGoalsArray.append(goal)
                userData.updateOverall()
            }
        }
        
    }
    
    func restoreGoal (_ userData: goalScreenInfo,_ goal:Goal){
        withAnimation(.easeOut) {
            goal.state = .active
            let goalIndex = getGoalIndex(from: userData.deletedGoalsArray, user: goal)!
            
            userData.deletedGoalsArray.remove(at: goalIndex)
            userData.activeGoalsArray.append(goal)
            userData.updateOverall()
            
        }
        
    }
    
    func completeGoal(_ userData: goalScreenInfo,_ goal:Goal){
        withAnimation(.easeOut) {
            let oldState = goal.state
            goal.state = .completed
            goal.extras.startingNum = 0
            
            if whatBottomTextType(goal) == 0 {
                goal.timesCompleted += 1
            }
            
            if oldState == .doneToday {
                let goalIndex = getGoalIndex(from: userData.completedForToday, user: goal)!
                for completedGoal in userData.completedGoalsArray {
                    if goal.goalID == completedGoal.goalID {
                        completedGoal.timesCompleted += 1
                        userData.completedForToday.remove(at: goalIndex)
                        userData.updateOverall()
                        return
                    }
                }
                
                userData.completedForToday.remove(at: goalIndex)
                userData.completedGoalsArray.append(goal)
                userData.updateOverall()
            } else {
                let goalIndex = getGoalIndex(from: userData.activeGoalsArray, user: goal)!
                for completedGoal in userData.completedGoalsArray {
                    if goal.goalID == completedGoal.goalID {
                        completedGoal.timesCompleted += 1
                        userData.activeGoalsArray.remove(at: goalIndex)
                        userData.updateOverall()
                        return
                    }
                }
                
                userData.activeGoalsArray.remove(at: goalIndex)
                userData.completedGoalsArray.append(goal)
                userData.updateOverall()
            }
        }
    }
    
    func doneTodayGoal(_ userData: goalScreenInfo,_ goal:Goal){
        withAnimation(.easeOut) {
            goal.state = .doneToday
            let goalIndex = getGoalIndex(from: userData.activeGoalsArray, user: goal)!
            
            if whatBottomTextType(goal) == 1 {
                goal.goalInformation.durationAmount = ("\(Int(goal.goalInformation.durationAmount)! - 1)")
            } else if whatBottomTextType(goal) == 2 {
                goal.timesCompleted += 1
            }
            
            userData.activeGoalsArray.remove(at: goalIndex)
            userData.completedForToday.append(goal)
            userData.updateOverall()
            
        }
    }
    
    func goneGoal(_ userData: goalScreenInfo,_ goal:Goal){
        withAnimation(.easeOut) {
            goal.state = .gone
            let goalIndex = getGoalIndex(from: userData.deletedGoalsArray, user: goal)!
            
            userData.deletedGoalsArray.remove(at: goalIndex)
            userData.updateOverall()
        }
    }
    
}

class GoalExtras {
    
    @Published var directionsForUser: [String]? = []
    @Published var startingNum: Int = 0
    
}
