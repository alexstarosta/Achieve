//
//  NewGoalView.swift
//  Achieve
//
//  Created by swift on 2022-07-29.
//

import SwiftUI

func whatAmount (_ goal: Goal) -> Int {
    if goal.goalInformation.selectedAmountSpec == 1 {
        if goal.goalInformation.goalAmount != "" && onlyNumbers(goal.goalInformation.goalAmount){
            return Int(goal.goalInformation.goalAmount)!
        }
    } else if goal.goalInformation.selectedAmountSpec == 2 {
        if goal.goalInformation.amountDurationAmount != "" && onlyNumbers(goal.goalInformation.amountDurationAmount){
            return Int(goal.goalInformation.amountDurationAmount)!
        }
    }
    return -1
}

func whatBottomText (_ goal: Goal) -> String {
    if goal.goalInformation.selfDirected == true { return "" }
    if goal.goalInformation.selectedTimeSpec == 1 {
        if goal.goalInformation.durationSpec == 1 && goal.goalInformation.durationAmount != "" && onlyNumbers(goal.goalInformation.durationAmount) {
            if goal.goalInformation.scheduleType == 1 {
                return " Days Left"
            } else if goal.goalInformation.scheduleType == 2 {
                return " Weeks Left"
            } else if goal.goalInformation.scheduleType == 3 {
                return " Months Left"
            }
        }
        return "Times Completed: "
    } else if goal.goalInformation.selectedTimeSpec == 2 {
        return "Finish Date: "
    }
    return ""
}

func whatBottomTextType (_ goal: Goal) -> Int {
    if goal.goalInformation.selfDirected == true { return 0 }
    if goal.goalInformation.selectedTimeSpec == 1 {
        if goal.goalInformation.durationSpec == 1 && goal.goalInformation.durationAmount != "" && onlyNumbers(goal.goalInformation.durationAmount) {
            return 1
        }
        return 2
    } else if goal.goalInformation.selectedTimeSpec == 2 {
        return 3
    }
    return 0
}

func isProgressNeeded (_ goal: Goal) -> Bool {
    if goal.goalInformation.selectedAmountSpec == 3{
        return false
    }
    if goal.goalInformation.selfDirected {
        return false
    }
    return true
}

struct NewGoalView: View {
    
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var localUserData: LocalUserData
    
    let goal: Goal
    
    let startNumber = 0
    
    func completeFunc() {
        
        if localUserData.disableCompletion == false {
            localUserData.latestCompleteInfo = goal
            localUserData.latestCompleteTextType = whatBottomTextType(goal)
            localUserData.showingGoalCompleted = true
        } else {
            goal.completeGoal(userData, goal)
        }
        
    }
    
    func deleteFunc (){
        goal.deleteGoal(userData, goal)
    }
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25, style: .circular)
                .frame(width: screenWidth*0.425*2.125, height: screenWidth*0.425, alignment: .leading)
                .padding(.bottom, 10)
                .foregroundColor(goal.backgroundColor.opacity(0.2))
                .foregroundStyle(.ultraThinMaterial)
            
            HStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 60, height: 60, alignment: .leading)
                        .foregroundColor(goal.accentColor.opacity(0.2))
                        .foregroundStyle(.ultraThinMaterial)
                    
                    Text("\(goal.catagory?.symbol ?? Image(systemName: "flag.fill"))")
                        .scaleEffect(1.8)
                        .foregroundColor(goal.accentColor)
                }
                .padding(.trailing, 15)
                
                if goal.displayTitle == "" {
                    Text("\(goal.title)")
                        .font(.body.bold())
                        .frame(width: 190, alignment: .topLeading)
                        .frame(minHeight: 20, idealHeight: 20, maxHeight: 50, alignment: .leading)
                } else {
                    Text("\(goal.displayTitle)")
                        .font(.body.bold())
                        .frame(width: 190, alignment: .topLeading)
                        .frame(minHeight: 20, idealHeight: 20, maxHeight: 50, alignment: .leading)
                }
                
                Spacer()
                
                ZStack{
                    RoundedRectangle(cornerRadius: 22)
                        .frame(width: 20, height: 50, alignment: .bottom)
                        .foregroundColor(goal.accentColor.opacity(0.2))
                        .foregroundStyle(.ultraThinMaterial)
                    
                    Menu("\(Image(systemName: "ellipsis"))") {
                        Button("Delete Goal", action: deleteFunc)
                        if goal.state == .doneToday &&  whatBottomTextType(goal) == 2 && goal.timesCompleted > 0{
                            Button("Complete Goal", action: completeFunc)
                        }
                    }
                    .rotationEffect(.degrees(90))
                    .foregroundColor(goal.accentColor)
                }
                
                
            }
            .offset(y: -45)
            .frame(width: screenWidth*0.4*2)
            
            ProgressView(
                goal: goal,
                startNumber: 0,
                endNumber: whatAmount(goal),
                isProgress: isProgressNeeded(goal),
                accentColor: goal.accentColor,
                backgroundColor: goal.backgroundColor,
                isIncremented: goal.goalInformation.isGoalIncrement == 1 ? true : false,
                incrementAmount: Int(goal.goalInformation.goalIncrement) ?? 0,
                bottomText: whatBottomText(goal),
                bottomTextType: whatBottomTextType(goal),
                finishDate: goal.goalInformation.finishDate
            )
            .offset(y: 25)
            
        }
    }
}
