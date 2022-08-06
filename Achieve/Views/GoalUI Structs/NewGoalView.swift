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
    
    @EnvironmentObject var screenInfo: goalScreenInfo
    
    let goal: Goal
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    let screenSize = UIScreen.main.bounds.size
    
    let startNumber = 0
    
    func goalCompleted() {
        goal.state = .completed
        goal.extras.startingNum = 0
        screenInfo.refresh.toggle()
        
        if screenInfo.completedForToday.count-1 < 0 {
            return
        }
        
        for index in 0...screenInfo.completedForToday.count-1 {
            if screenInfo.completedForToday[index].state == .completed {
                screenInfo.completedGoalsArray.append(screenInfo.completedForToday[index])
                screenInfo.completedForToday.remove(at: index)
                screenInfo.catagoryScores = catagoryPrecedence(screenInfo.activeGoalsArray)
                screenInfo.progressionEnd = currentProgressTotal(screenInfo.activeGoalsArray)
                screenInfo.progressionStart = currentProgressStart(screenInfo.activeGoalsArray)
                break
            }
        }
    }
    
    func deleteGoal() {
        let oldState = goal.state
        withAnimation(.easeOut) {
            goal.state = .deleted
            screenInfo.refresh.toggle()
            
            if oldState == .doneToday {
                for index in 0...screenInfo.completedForToday.count-1 {
                    if screenInfo.completedForToday[index].state == .deleted {
                        screenInfo.deletedGoalsArray.append(screenInfo.completedForToday[index])
                        screenInfo.completedForToday.remove(at: index)
                        screenInfo.progressionEnd = currentProgressTotal(screenInfo.activeGoalsArray)
                        screenInfo.progressionStart = currentProgressStart(screenInfo.activeGoalsArray)
                        screenInfo.catagoryScores = catagoryPrecedence(screenInfo.activeGoalsArray)
                        break
                    }
                }
            } else {
                for index in 0...screenInfo.activeGoalsArray.count-1 {
                    if screenInfo.activeGoalsArray[index].state == .deleted {
                        screenInfo.deletedGoalsArray.append(screenInfo.activeGoalsArray[index])
                        screenInfo.activeGoalsArray.remove(at: index)
                        screenInfo.progressionEnd = currentProgressTotal(screenInfo.activeGoalsArray)
                        screenInfo.progressionStart = currentProgressStart(screenInfo.activeGoalsArray)
                        screenInfo.catagoryScores = catagoryPrecedence(screenInfo.activeGoalsArray)
                        break
                    }
                }
            }
        }
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
                        Button("Delete Goal", action: deleteGoal)
                        if goal.state == .doneToday &&  whatBottomTextType(goal) == 2 && goal.timesCompleted > 0{
                            Button("Complete Goal", action: goalCompleted)
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
