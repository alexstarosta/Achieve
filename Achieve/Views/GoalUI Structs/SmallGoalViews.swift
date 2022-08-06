//
//  SmallGoalViews.swift
//  Achieve
//
//  Created by swift on 2022-07-29.
//

import SwiftUI

struct smallCompletedGoalView: View {
    
    let screenWidth = UIScreen.main.bounds.size.width
    
    @EnvironmentObject var screenInfo: goalScreenInfo
    
    let goal: Goal
    
    fileprivate func attachValues(_ copyGoal: Goal) {
        copyGoal.title = goal.title
        copyGoal.displayTitle = goal.displayTitle
        copyGoal.catagory = goal.catagory
        copyGoal.directionIndex = goal.directionIndex
        copyGoal.goalInformation = goal.goalInformation
        copyGoal.accentColor = goal.accentColor
        copyGoal.backgroundColor = goal.backgroundColor
        copyGoal.state = goal.state
        copyGoal.goalID = goal.goalID
    }
    
    func repeatGoal () {
        withAnimation(.easeOut) {
            
            for activegoal in screenInfo.activeGoalsArray {
                if goal.goalID == activegoal.goalID{
                    return
                }
            }
                
            let copyGoal = Goal()
            
            attachValues(copyGoal)
            
            copyGoal.state = .active
            screenInfo.activeGoalsArray.append(copyGoal)
            screenInfo.refresh.toggle()
            
            screenInfo.catagoryScores = catagoryPrecedence(screenInfo.activeGoalsArray)
            screenInfo.progressionEnd = currentProgressTotal(screenInfo.activeGoalsArray)
            screenInfo.progressionStart = currentProgressStart(screenInfo.activeGoalsArray)
        }
    }
    
    var body: some View {
        ZStack{
            
            RoundedRectangle(cornerRadius: 25, style: .circular)
                .frame(width: screenWidth*0.425*2.125, height: screenWidth*0.425/2, alignment: .leading)
                .padding(.bottom, 10)
                .foregroundColor(goal.backgroundColor.opacity(0.2))
                .foregroundStyle(.ultraThinMaterial)
            
            HStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 60, height: 60, alignment: .leading)
                        .foregroundColor(goal.accentColor.opacity(0.2))
                        .foregroundStyle(.ultraThinMaterial)
                    
                    if goal.timesCompleted < 2 {
                        Text("\(goal.catagory?.symbol ?? Image(systemName: "flag.fill"))")
                            .scaleEffect(1.8)
                            .foregroundColor(goal.accentColor)
                    } else {
                        Text("\(goal.timesCompleted)x")
                            .font(.largeTitle.bold())
                            .foregroundColor(goal.accentColor)
                    }
                    
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
                        if whatBottomTextType(goal) == 0 {
                            Button("Repeat Goal", action: repeatGoal)
                        } else {
                            Text("Cannot repeat this goal at this time")
                        }
                    }
                    .rotationEffect(.degrees(90))
                    .foregroundColor(goal.accentColor)
                }
                
                
            }
            .offset(y: -5)
            .frame(width: screenWidth*0.4*2)
        }
    }
    
}

struct smallDeletedGoalView: View {
    
    let screenWidth = UIScreen.main.bounds.size.width
    
    @EnvironmentObject var screenInfo: goalScreenInfo
    
    let goal: Goal
    
    func restoreGoal () {
        withAnimation(.easeOut) {
            goal.state = .active
            screenInfo.refresh.toggle()
            
            for index in 0...screenInfo.deletedGoalsArray.count-1 {
                if screenInfo.deletedGoalsArray[index].state == .active {
                    screenInfo.activeGoalsArray.append(screenInfo.deletedGoalsArray[index])
                    screenInfo.deletedGoalsArray.remove(at: index)
                    screenInfo.catagoryScores = catagoryPrecedence(screenInfo.activeGoalsArray)
                    screenInfo.progressionEnd = currentProgressTotal(screenInfo.activeGoalsArray)
                    screenInfo.progressionStart = currentProgressStart(screenInfo.activeGoalsArray)
                    break
                }
            }
        }
    }
    
    func deleteForever() {
        goal.state = .gone
        for index in 0...screenInfo.deletedGoalsArray.count-1 {
            if screenInfo.deletedGoalsArray[index].state == .gone {
                screenInfo.deletedGoalsArray.remove(at: index)
                screenInfo.catagoryScores = catagoryPrecedence(screenInfo.activeGoalsArray)
                screenInfo.progressionEnd = currentProgressTotal(screenInfo.activeGoalsArray)
                screenInfo.progressionStart = currentProgressStart(screenInfo.activeGoalsArray)
                break
            }
        }
    }
    
    var body: some View {
        ZStack{
            
            RoundedRectangle(cornerRadius: 25, style: .circular)
                .frame(width: screenWidth*0.425*2.125, height: screenWidth*0.425/2, alignment: .leading)
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
                            Button("Delete Forever", action: deleteForever)
                        if whatBottomTextType(goal) == 0 {
                            Button("Restore Goal", action: restoreGoal)
                        } else {
                            Text("Cannot restore this goal at this time")
                        }
                    }
                    .rotationEffect(.degrees(90))
                    .foregroundColor(goal.accentColor)
                }
                
                
            }
            .offset(y: -5)
            .frame(width: screenWidth*0.4*2)
        }
    }
    
}

struct smallGoalView: View {
        
        let screenWidth = UIScreen.main.bounds.size.width
        
        @EnvironmentObject var screenInfo: goalScreenInfo
        let goal: Goal
        
        var body: some View {
            ZStack{
                
                RoundedRectangle(cornerRadius: 25, style: .circular)
                    .frame(width: screenWidth*0.425*2.125, height: screenWidth*0.425/2, alignment: .leading)
                    .padding(.bottom, 10)
                    .foregroundColor(goal.backgroundColor.opacity(0.2))
                    .foregroundStyle(.ultraThinMaterial)
                
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 60, height: 60, alignment: .leading)
                            .foregroundColor(goal.accentColor.opacity(0.2))
                            .foregroundStyle(.ultraThinMaterial)
                        
                        if goal.timesCompleted < 2 {
                            Text("\(goal.catagory?.symbol ?? Image(systemName: "flag.fill"))")
                                .scaleEffect(1.8)
                                .foregroundColor(goal.accentColor)
                        } else {
                            Text("\(goal.timesCompleted)x")
                                .font(.largeTitle.bold())
                                .foregroundColor(goal.accentColor)
                        }
                        
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
                    
                }
                .offset(y: -5)
                .frame(width: screenWidth*0.4*2)
            }
    }
        
}

