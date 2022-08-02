//
//  NewGoalView.swift
//  Achieve
//
//  Created by swift on 2022-07-29.
//

import SwiftUI

func whatAmount (_ goalinfo: newGoalInfo) -> Int {
    if goalinfo.goalSpecs.selectedAmountSpec == 1 {
        if goalinfo.goalSpecs.goalAmount != "" && onlyNumbers(goalinfo.goalSpecs.goalAmount){
            return Int(goalinfo.goalSpecs.goalAmount)!
        }
    } else if goalinfo.goalSpecs.selectedAmountSpec == 2 {
        if goalinfo.goalSpecs.amountDurationAmount != "" && onlyNumbers(goalinfo.goalSpecs.amountDurationAmount){
            return Int(goalinfo.goalSpecs.amountDurationAmount)!
        }
    }
    return -1
}

func whatBottomText (_ goalinfo: newGoalInfo) -> String {
    if goalinfo.goalSpecs.selfDirected == true { return "" }
    if goalinfo.goalSpecs.selectedTimeSpec == 1 {
        if goalinfo.goalSpecs.durationSpec == 1 && goalinfo.goalSpecs.durationAmount != "" && onlyNumbers(goalinfo.goalSpecs.durationAmount) {
            if goalinfo.goalSpecs.scheduleType == 1 {
                return " Days Left"
            } else if goalinfo.goalSpecs.scheduleType == 2 {
                return " Weeks Left"
            } else if goalinfo.goalSpecs.scheduleType == 3 {
                return " Months Left"
            }
        }
        return "Times Completed: "
    } else if goalinfo.goalSpecs.selectedTimeSpec == 2 {
        return "Finish Date: "
    }
    return ""
}

func whatBottomTextType (_ goalinfo: newGoalInfo) -> Int {
    if goalinfo.goalSpecs.selfDirected == true { return 0 }
    if goalinfo.goalSpecs.selectedTimeSpec == 1 {
        if goalinfo.goalSpecs.durationSpec == 1 && goalinfo.goalSpecs.durationAmount != "" && onlyNumbers(goalinfo.goalSpecs.durationAmount) {
            return 1
        }
        return 2
    } else if goalinfo.goalSpecs.selectedTimeSpec == 2 {
        return 3
    }
    return 0
}

func isProgressNeeded (_ goalinfo: newGoalInfo) -> Bool {
    if goalinfo.goalSpecs.selectedAmountSpec == 3{
        return false
    }
    if goalinfo.goalSpecs.selfDirected {
        return false
    }
    return true
}

struct NewGoalView: View {
    
    @EnvironmentObject var screenInfo: goalScreenInfo
    
    let info: newGoalInfo
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    let screenSize = UIScreen.main.bounds.size
    
    let startNumber = 0
    
    func goalCompleted() {
        info.isCompleted = true
        info.startingNum = 0
        screenInfo.refresh.toggle()
        
        if screenInfo.completedForToday.count-1 < 0 {
            return
        }
        
        for index in 0...screenInfo.completedForToday.count-1 {
            if screenInfo.completedForToday[index].isCompleted {
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
        withAnimation(.easeOut) {
            info.isDeleted = true
            info.startingNum = 0
            screenInfo.refresh.toggle()
            
            if info.isDoneForToday {
                for index in 0...screenInfo.completedForToday.count-1 {
                    if screenInfo.completedForToday[index].isDeleted {
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
                    if screenInfo.activeGoalsArray[index].isDeleted {
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
                .foregroundColor(info.backgroundColor.opacity(0.2))
                .foregroundStyle(.ultraThinMaterial)
            
            HStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 60, height: 60, alignment: .leading)
                        .foregroundColor(info.accentColor.opacity(0.2))
                        .foregroundStyle(.ultraThinMaterial)
                    
                    Text("\(info.catagory?.symbol ?? Image(systemName: "flag.fill"))")
                        .scaleEffect(1.8)
                        .foregroundColor(info.accentColor)
                }
                .padding(.trailing, 15)
                
                if info.displayTitle == "" {
                    Text("\(info.title)")
                        .font(.body.bold())
                        .frame(width: 190, alignment: .topLeading)
                        .frame(minHeight: 20, idealHeight: 20, maxHeight: 50, alignment: .leading)
                } else {
                    Text("\(info.displayTitle)")
                        .font(.body.bold())
                        .frame(width: 190, alignment: .topLeading)
                        .frame(minHeight: 20, idealHeight: 20, maxHeight: 50, alignment: .leading)
                }
                
                Spacer()
                
                ZStack{
                    RoundedRectangle(cornerRadius: 22)
                        .frame(width: 20, height: 50, alignment: .bottom)
                        .foregroundColor(info.accentColor.opacity(0.2))
                        .foregroundStyle(.ultraThinMaterial)
                    
                    Menu("\(Image(systemName: "ellipsis"))") {
                        Button("Delete Goal", action: deleteGoal)
                        if info.greyOut == true && info.isDoneForToday == true &&  whatBottomTextType(info) == 2 && info.timesCompleted > 0{
                            Button("Complete Goal", action: goalCompleted)
                        }
                    }
                    .rotationEffect(.degrees(90))
                    .foregroundColor(info.accentColor)
                }
                
                
            }
            .offset(y: -45)
            .frame(width: screenWidth*0.4*2)
            
            ProgressView(
                info: info,
                startNumber: 0,
                endNumber: whatAmount(info),
                isProgress: isProgressNeeded(info),
                accentColor: info.accentColor,
                backgroundColor: info.backgroundColor,
                isIncremented: info.goalSpecs.isGoalIncrement == 1 ? true : false,
                incrementAmount: Int(info.goalSpecs.goalIncrement) ?? 0,
                bottomText: whatBottomText(info),
                bottomTextType: whatBottomTextType(info),
                finishDate: info.goalSpecs.finishDate
            )
            .offset(y: 25)
            
        }
    }
}
