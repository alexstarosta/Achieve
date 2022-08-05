//
//  CompleteView.swift
//  Achieve
//
//  Created by swift on 2022-07-30.
//

import SwiftUI

struct CompleteView: View {

    @EnvironmentObject var screenInfo: goalScreenInfo
    let goalInfo: newGoalInfo
    let bottomTextType: Int

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            ZStack{
                Circle()
                    .foregroundStyle(achieveStyleSimple)
                    .frame(width: 100, height: 100, alignment: .center)
                Image("party.popper.fill")
                    .scaleEffect(1.75)
                    .foregroundColor(Color(UIColor.systemBackground))
            }
            .padding(.top, 190)
            
            Text("Goal Complete!")
                .multilineTextAlignment(.center)
                .font(.largeTitle.bold())
            
            smallGoalView(info: goalInfo)
            
            Button(action: {
                goalInfo.isCompleted = false
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Undo Goal Completion")
                    .frame(width: screenWidth*0.425*2.125 - 100, height: 40)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            
            Button(action: {
                goalInfo.isCompleted = true
                goalInfo.startingNum = 0
                if bottomTextType != 1 && bottomTextType != 2 && bottomTextType != 3 {
                    goalInfo.timesCompleted += 1
                }
                screenInfo.refresh.toggle()
                
                for completedGoal in screenInfo.completedGoalsArray {
                    if goalInfo.title == completedGoal.title && goalInfo.goalSpecs.goalAmount == completedGoal.goalSpecs.goalAmount && goalInfo.displayTitle == completedGoal.displayTitle && goalInfo.goalSpecs.selfDirected == completedGoal.goalSpecs.selfDirected && goalInfo.accentColor == completedGoal.accentColor && goalInfo.backgroundColor == completedGoal.backgroundColor {
                        completedGoal.timesCompleted += 1
                        if screenInfo.activeGoalsArray.count == 1 {
                            if screenInfo.activeGoalsArray[0].isCompleted {
                                screenInfo.activeGoalsArray.remove(at: 0)
                                screenInfo.catagoryScores = catagoryPrecedence(screenInfo.activeGoalsArray)
                                screenInfo.progressionEnd = currentProgressTotal(screenInfo.activeGoalsArray)
                                screenInfo.progressionStart = currentProgressStart(screenInfo.activeGoalsArray)
                                screenInfo.showingGoalCompleted = false
                                self.presentationMode.wrappedValue.dismiss()
                                return
                            }
                        }
                        for index in 0...screenInfo.activeGoalsArray.count-1 {
                            if screenInfo.activeGoalsArray[index].isCompleted {
                                screenInfo.activeGoalsArray.remove(at: index)
                                screenInfo.catagoryScores = catagoryPrecedence(screenInfo.activeGoalsArray)
                                screenInfo.progressionEnd = currentProgressTotal(screenInfo.activeGoalsArray)
                                screenInfo.progressionStart = currentProgressStart(screenInfo.activeGoalsArray)
                                screenInfo.showingGoalCompleted = false
                                self.presentationMode.wrappedValue.dismiss()
                                return
                            }
                        }
                    }
                }
                if screenInfo.activeGoalsArray.count == 1 {
                    if screenInfo.activeGoalsArray[0].isCompleted {
                        screenInfo.completedGoalsArray.append(screenInfo.activeGoalsArray[0])
                        screenInfo.activeGoalsArray.remove(at: 0)
                        screenInfo.catagoryScores = catagoryPrecedence(screenInfo.activeGoalsArray)
                        screenInfo.progressionEnd = currentProgressTotal(screenInfo.activeGoalsArray)
                        screenInfo.progressionStart = currentProgressStart(screenInfo.activeGoalsArray)
                        screenInfo.showingGoalCompleted = false
                        self.presentationMode.wrappedValue.dismiss()
                        return
                    }
                }
                for index in 0...screenInfo.activeGoalsArray.count-1 {
                    if screenInfo.activeGoalsArray[index].isCompleted {
                        screenInfo.completedGoalsArray.append(screenInfo.activeGoalsArray[index])
                        screenInfo.activeGoalsArray.remove(at: index)
                        screenInfo.catagoryScores = catagoryPrecedence(screenInfo.activeGoalsArray)
                        screenInfo.progressionEnd = currentProgressTotal(screenInfo.activeGoalsArray)
                        screenInfo.progressionStart = currentProgressStart(screenInfo.activeGoalsArray)
                        screenInfo.showingGoalCompleted = false
                        self.presentationMode.wrappedValue.dismiss()
                        return
                    }
                }
            }) {
                Text("Continue")
                    .frame(width: screenWidth*0.425*2.125 - 100, height: 40)
                    .background (LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .foregroundColor(Color(UIColor.systemBackground))
                    .cornerRadius(40)
                    .font(.body.bold())
                    .padding(.bottom)
            }
            .frame(maxHeight: 60, alignment: .bottom)
        }
    }
}

struct CompleteView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteView(goalInfo: newGoalInfo(), bottomTextType: 0)
    }
}
