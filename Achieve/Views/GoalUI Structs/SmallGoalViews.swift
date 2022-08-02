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
    
    let info: newGoalInfo
    
    fileprivate func attachValues(_ copyGoal: newGoalInfo) {
        copyGoal.title = info.title
        copyGoal.displayTitle = info.displayTitle
        copyGoal.catagory = info.catagory
        copyGoal.directionIndex = info.directionIndex
        copyGoal.goalSpecs = info.goalSpecs
        copyGoal.accentColor = info.accentColor
        copyGoal.backgroundColor = info.backgroundColor
        copyGoal.isCompleted = info.isCompleted
        copyGoal.currentlyCustom = info.currentlyCustom
    }
    
    func repeatGoal () {
        withAnimation(.easeOut) {
            
            for activegoals in screenInfo.activeGoalsArray {
                if info.title == activegoals.title && info.goalSpecs.goalAmount == activegoals.goalSpecs.goalAmount && info.displayTitle == activegoals.displayTitle && info.goalSpecs.selfDirected == activegoals.goalSpecs.selfDirected && info.accentColor == activegoals.accentColor && info.backgroundColor == activegoals.backgroundColor {
                    info.showRepeatError = true
                    return
                }
            }
            
            info.showRepeatError = false
                
            let copyGoal = newGoalInfo()
            
            attachValues(copyGoal)
            
            copyGoal.isCompleted = false
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
                .foregroundColor(info.backgroundColor.opacity(0.2))
                .foregroundStyle(.ultraThinMaterial)
            
            HStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 60, height: 60, alignment: .leading)
                        .foregroundColor(info.accentColor.opacity(0.2))
                        .foregroundStyle(.ultraThinMaterial)
                    
                    if info.timesCompleted < 2 {
                        Text("\(info.catagory?.symbol ?? Image(systemName: "flag.fill"))")
                            .scaleEffect(1.8)
                            .foregroundColor(info.accentColor)
                    } else {
                        Text("\(info.timesCompleted)x")
                            .font(.largeTitle.bold())
                            .foregroundColor(info.accentColor)
                    }
                    
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
                        if whatBottomTextType(info) == 0 {
                            Button("Repeat Goal", action: repeatGoal)
                        } else {
                            Text("Cannot repeat this goal at this time")
                        }
                        if info.showRepeatError {
                            Text("You cant have two repeats active at the same time")
                        }
                    }
                    .rotationEffect(.degrees(90))
                    .foregroundColor(info.accentColor)
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
    
    let info: newGoalInfo
    
    func restoreGoal () {
        withAnimation(.easeOut) {
            info.isDeleted = false
            screenInfo.refresh.toggle()
            
            for index in 0...screenInfo.deletedGoalsArray.count-1 {
                if screenInfo.deletedGoalsArray[index].isDeleted == false {
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
        info.isGone = true
        for index in 0...screenInfo.deletedGoalsArray.count-1 {
            if screenInfo.deletedGoalsArray[index].isGone == true {
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
                            Button("Delete Forever", action: deleteForever)
                        if whatBottomTextType(info) == 0 {
                            Button("Restore Goal", action: restoreGoal)
                        } else {
                            Text("Cannot restore this goal at this time")
                        }
                    }
                    .rotationEffect(.degrees(90))
                    .foregroundColor(info.accentColor)
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
        let info: newGoalInfo
        
        var body: some View {
            ZStack{
                
                RoundedRectangle(cornerRadius: 25, style: .circular)
                    .frame(width: screenWidth*0.425*2.125, height: screenWidth*0.425/2, alignment: .leading)
                    .padding(.bottom, 10)
                    .foregroundColor(info.backgroundColor.opacity(0.2))
                    .foregroundStyle(.ultraThinMaterial)
                
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 60, height: 60, alignment: .leading)
                            .foregroundColor(info.accentColor.opacity(0.2))
                            .foregroundStyle(.ultraThinMaterial)
                        
                        if info.timesCompleted < 2 {
                            Text("\(info.catagory?.symbol ?? Image(systemName: "flag.fill"))")
                                .scaleEffect(1.8)
                                .foregroundColor(info.accentColor)
                        } else {
                            Text("\(info.timesCompleted)x")
                                .font(.largeTitle.bold())
                                .foregroundColor(info.accentColor)
                        }
                        
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
                    
                }
                .offset(y: -5)
                .frame(width: screenWidth*0.4*2)
            }
    }
        
}

