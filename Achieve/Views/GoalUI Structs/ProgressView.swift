//
//  ProgressView.swift
//  Achieve
//
//  Created by swift on 2022-07-29.
//

import SwiftUI

struct ProgressView: View {
    
    @EnvironmentObject var screenInfo: goalScreenInfo
    
    let info: newGoalInfo
    
    let screenWidth = UIScreen.main.bounds.size.width
    
    @State var startNumber: Int
    let endNumber: Int
    
    let isProgress: Bool
    
    let accentColor: Color
    let backgroundColor: Color
    
    let isIncremented: Bool
    let incrementAmount: Int
    
    let bottomText: String
    let bottomTextType: Int
    let finishDate: Date?
    
    @State private var timer: Timer?
    @State var isLongPressingPlus = false
    @State var isLongPressingMinus = false
    
    func addOne() {
        
        if info.greyOut == true { return }
        
        if startNumber >= 0 && startNumber < endNumber {
            startNumber += 1
            if info.currentlyCustom == false {
                info.startingNum += 1
                screenInfo.progressionEnd = currentProgressTotal(screenInfo.activeGoalsArray)
                screenInfo.progressionStart = currentProgressStart(screenInfo.activeGoalsArray)
            }
        }
        if info.currentlyCustom != true {
            if startNumber == endNumber {
                if bottomTextType != 1 && bottomTextType != 2 && bottomTextType != 3 {
                    goalCompleted()
                } else {
                    doneForToday()
                }
            }
        }
    }
    
    func minusOne() {
        
        if info.greyOut == true { return }
        
        if startNumber >= 1 {
            startNumber -= 1
            if info.currentlyCustom == false {
                info.startingNum -= 1
                screenInfo.progressionEnd = currentProgressTotal(screenInfo.activeGoalsArray)
                screenInfo.progressionStart = currentProgressStart(screenInfo.activeGoalsArray)
            }
        }
    }
    
    func goalCompleted() {
        
        if info.greyOut == true { return }
        
        if screenInfo.disableCompletion == false {
            screenInfo.latestCompleteInfo = info
            screenInfo.latestCompleteTextType = bottomTextType
            screenInfo.showingGoalCompleted = true
        } else {
            info.isCompleted = true
            if bottomTextType != 1 && bottomTextType != 2 && bottomTextType != 3 {
                info.timesCompleted += 1
            }
            info.startingNum = 0
            screenInfo.refresh.toggle()
            
            for completedGoal in screenInfo.completedGoalsArray {
                if info.title == completedGoal.title && info.goalSpecs.goalAmount == completedGoal.goalSpecs.goalAmount && info.displayTitle == completedGoal.displayTitle && info.goalSpecs.selfDirected == completedGoal.goalSpecs.selfDirected && info.accentColor == completedGoal.accentColor && info.backgroundColor == completedGoal.backgroundColor {
                    completedGoal.timesCompleted += 1
                    for index in 0...screenInfo.activeGoalsArray.count-1 {
                        if screenInfo.activeGoalsArray[index].isCompleted {
                            screenInfo.activeGoalsArray.remove(at: index)
                            screenInfo.catagoryScores = catagoryPrecedence(screenInfo.activeGoalsArray)
                            screenInfo.progressionEnd = currentProgressTotal(screenInfo.activeGoalsArray)
                            screenInfo.progressionStart = currentProgressStart(screenInfo.activeGoalsArray)
                            return
                        }
                    }
                }
            }
            
            for index in 0...screenInfo.activeGoalsArray.count-1 {
                if screenInfo.activeGoalsArray[index].isCompleted {
                    screenInfo.completedGoalsArray.append(screenInfo.activeGoalsArray[index])
                    screenInfo.activeGoalsArray.remove(at: index)
                    screenInfo.catagoryScores = catagoryPrecedence(screenInfo.activeGoalsArray)
                    screenInfo.progressionEnd = currentProgressTotal(screenInfo.activeGoalsArray)
                    screenInfo.progressionStart = currentProgressStart(screenInfo.activeGoalsArray)
                    break
                }
            }
        }
        
    }
    
    func doneForToday () {
        
        if info.greyOut == true { return }
        if info.currentlyCustom == true { return }
        
        info.greyOut = true
        info.isDoneForToday = true
        
        if bottomTextType == 1{
            info.goalSpecs.durationAmount = ("\(Int(info.goalSpecs.durationAmount)! - 1)")
        } else if bottomTextType == 2{
            info.timesCompleted += 1
        }
        
        for index in 0...screenInfo.activeGoalsArray.count-1 {
            if screenInfo.activeGoalsArray[index].isDoneForToday {
                screenInfo.completedForToday.append(screenInfo.activeGoalsArray[index])
                screenInfo.activeGoalsArray.remove(at: index)
                screenInfo.catagoryScores = catagoryPrecedence(screenInfo.activeGoalsArray)
                screenInfo.progressionEnd = currentProgressTotal(screenInfo.activeGoalsArray)
                screenInfo.progressionStart = currentProgressStart(screenInfo.activeGoalsArray)
                break
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .leading){
            
            if isProgress {
                HStack{
                    Text("\(startNumber)/\(endNumber)")
                    Spacer()
                    if bottomTextType == 1{
                        Text(info.goalSpecs.durationAmount + "\(bottomText)")
                    } else if bottomTextType == 2{
                        Text("\(bottomText) \(info.timesCompleted)")
                    } else if bottomTextType == 3{
                        Text("\(bottomText) \(finishDate!.formatted(date: .long, time: .omitted))")
                    } else {
                        Text("\(Double(startNumber)/Double(endNumber)*100, specifier: "%.f")%")
                    }
                }
                .offset(y: -20)
                .frame(width: screenWidth*0.4*2)
            } else {
                HStack{
                    if bottomTextType == 1{
                        Text(info.goalSpecs.durationAmount + "\(bottomText)")
                    } else if bottomTextType == 2{
                        Text("\(bottomText) \(info.timesCompleted)")
                    } else if bottomTextType == 3{
                        Text("\(bottomText) \(finishDate!.formatted(date: .long, time: .omitted))")
                    } else {
                        Text("You got this!")
                    }
                    Spacer()
                }
                .offset(y: -20)
                .frame(width: screenWidth*0.4*2)
            }
            
            RoundedRectangle(cornerRadius: 20)
                .frame(width: screenWidth*0.4*2, height: 12)
                .foregroundColor(accentColor.opacity(0.2))
                .foregroundStyle(.ultraThinMaterial)
            
            if isIncremented {
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(accentColor)
                        .foregroundStyle(.ultraThinMaterial)
                        .frame(width: !isProgress ? screenWidth*0.4*2 : (screenWidth*0.4*2)*CGFloat(Double(startNumber)/Double(endNumber)), height: 12, alignment: .leading)
                        .animation(.easeOut, value: Double(startNumber)/Double(endNumber))
                }
                .frame(width: screenWidth*0.4*2, height: 12, alignment: .leading)
                .mask({
                    HStack (spacing: 0){
                        ForEach(1...endNumber/incrementAmount, id: \.self) {_ in
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: (screenWidth*0.4*2)*(1/CGFloat(endNumber/incrementAmount)), height: 12, alignment: .leading)
                        }
                    }
                    .frame(width: screenWidth*0.4*2, height: 12, alignment: .leading)
                })
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(!isProgress ? LinearGradient(colors: [accentColor,.white.opacity(0.001), accentColor], startPoint: .leading, endPoint: .trailing): LinearGradient(colors: [accentColor], startPoint: .bottom, endPoint: .bottom))
                    .foregroundStyle(.ultraThinMaterial)
                    .frame(width: !isProgress ? screenWidth*0.4*2 : (screenWidth*0.4*2)*CGFloat(Double(startNumber)/Double(endNumber)), height: 12, alignment: .leading)
                    .animation(.easeOut, value: Double(startNumber)/Double(endNumber))
            }
            if isProgress {
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: screenWidth*0.4*2*0.15, height: 24)
                            .foregroundColor(accentColor.opacity(0.2))
                            .foregroundStyle(.ultraThinMaterial)
                        
                        Button(action: {
                            if(self.isLongPressingMinus){
                                self.isLongPressingMinus.toggle()
                                self.timer?.invalidate()
                                
                            } else {
                                minusOne()
                                
                            }
                        }, label: {
                            Image(systemName: self.isLongPressingMinus ? "gobackward.minus": "minus")
                                .foregroundColor(Color(UIColor.systemBackground))
                                .colorInvert()
                                .contentShape(Rectangle())
                        })
                        .simultaneousGesture(LongPressGesture(minimumDuration: 0.2).onEnded { _ in
                            self.isLongPressingMinus = true
                            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                                minusOne()
                            })
                        })
                    }

                    Spacer()
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: screenWidth*0.4*2*0.15, height: 24)
                            .foregroundColor(accentColor.opacity(0.2))
                            .foregroundStyle(.ultraThinMaterial)
                        
                        Button(action: {
                            if(self.isLongPressingPlus){
                                self.isLongPressingPlus.toggle()
                                self.timer?.invalidate()
                                
                            } else {
                                addOne()
                                
                            }
                        }, label: {
                            Image(systemName: self.isLongPressingPlus ? "goforward.plus": "plus")
                                .foregroundColor(Color(UIColor.systemBackground))
                                .colorInvert()
                                .contentShape(Rectangle())
                        })
                        .simultaneousGesture(LongPressGesture(minimumDuration: 0.2).onEnded { _ in
                            self.isLongPressingPlus = true
                            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                                addOne()
                            })
                        })
                    }
                    
                }
                .frame(width: screenWidth*0.4*2)
                .offset(x: 0, y: 22)
                
            } else {
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: screenWidth*0.4*2*0.5, height: 24)
                        .foregroundColor(accentColor.opacity(0.2))
                        .foregroundStyle(.ultraThinMaterial)
                    
                    Text("Complete?")
                        .bold()
                        .foregroundColor(Color(UIColor.systemBackground))
                        .colorInvert()
                }
                .frame(width: screenWidth*0.4*2, alignment: .center)
                .offset(x: 0, y: 26)
                .onTapGesture{
                    if bottomTextType != 1 && bottomTextType != 2 && bottomTextType != 3 {
                        goalCompleted()
                    } else {
                        doneForToday()
                    }
                }
            }
            
            if info.greyOut == true {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: screenWidth*0.4*2, height: 12)
                    .foregroundColor(Color.gray.opacity(0.5))
                    .foregroundStyle(.ultraThinMaterial)
            }
            
        }
    }
}
