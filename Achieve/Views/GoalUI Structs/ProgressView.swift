//
//  ProgressView.swift
//  Achieve
//
//  Created by swift on 2022-07-29.
//

import SwiftUI

struct ProgressView: View {
    
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var localUserData: LocalUserData
    
    let goal: Goal
    
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
        
        if goal.state == .doneToday { return }
        
        if startNumber >= 0 && startNumber < endNumber {
            startNumber += 1
            if goal.state != .custom {
                goal.extras.startingNum += 1
                userData.updateOverall()
            }
        }
        if goal.state != .custom {
            if startNumber == endNumber {
                if bottomTextType != 1 && bottomTextType != 2 && bottomTextType != 3 && goal.state != .completed {
                    goal.extras.startingNum = endNumber
                    completedFunc()
                } else {
                    doneTodayFunc()
                }
            }
        }
    }
    
    func minusOne() {
        
        if goal.state == .doneToday { return }
        
        if startNumber >= 1 {
            startNumber -= 1
            if goal.state != .custom {
                goal.extras.startingNum -= 1
                userData.updateOverall()
            }
        }
    }
    
    func completedFunc() {
        
        if goal.state == .doneToday { return }
        
        if localUserData.disableCompletion == false {
            localUserData.latestCompleteInfo = goal
            localUserData.latestCompleteTextType = bottomTextType
            localUserData.showingGoalCompleted = true
        } else {
            goal.completeGoal(userData, goal)
        }
        
    }
    
    func doneTodayFunc () {
        
        if goal.state == .custom { return }
        
        goal.doneTodayGoal(userData, goal)
        
    }
    
    var body: some View {
        ZStack(alignment: .leading){
            
            if isProgress {
                HStack{
                    Text("\(startNumber)/\(endNumber)")
                    Spacer()
                    if bottomTextType == 1{
                        Text(goal.goalInformation.durationAmount + "\(bottomText)")
                    } else if bottomTextType == 2{
                        Text("\(bottomText) \(goal.timesCompleted)")
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
                        Text(goal.goalInformation.durationAmount + "\(bottomText)")
                    } else if bottomTextType == 2{
                        Text("\(bottomText) \(goal.timesCompleted)")
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
                                if goal.extras.startingNum != endNumber - 1 {
                                    addOne()
                                }
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
                        completedFunc()
                    } else {
                        doneTodayFunc()
                    }
                }
            }
            
            if goal.state == .doneToday {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: screenWidth*0.4*2, height: 12)
                    .foregroundColor(Color.gray.opacity(0.5))
                    .foregroundStyle(.ultraThinMaterial)
            }
            
        }
    }
}
