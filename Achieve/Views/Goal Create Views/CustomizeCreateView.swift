//
//  CustomizeCreateView.swift
//  Achieve
//
//  Created by swift on 2022-07-27.
//

import SwiftUI

struct CustomizeCreateView: View {
    
    @EnvironmentObject var goal: Goal
    @EnvironmentObject var screenInfo: goalScreenInfo
    
    @State var selectedPicker = 1
    
    @State var exampleStarting = 0
    
    @State var displayError = false
    @State var errorText = ""
    @FocusState var isFocused
    
    func titleErrorCheck(_ title:String) -> String {
        let characterset = CharacterSet(charactersIn:
            "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 "
        )
        
        if title.rangeOfCharacter(from: characterset.inverted) != nil {
            return "No special characters allowed in title"
        }
        
        return "NI"
    }
    
    func whatAmount (_ goalinfo: Goal) -> Int {
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
    
    func whatBottomText (_ goalinfo: Goal) -> String {
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
    
    func whatBottomTextType (_ goalinfo: Goal) -> Int {
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
    
    func isProgressNeeded (_ goalinfo: Goal) -> Bool {
        if goal.goalInformation.selectedAmountSpec == 3{
            return false
        }
        if goal.goalInformation.selfDirected {
            return false
        }
        return true
    }
    
    var body: some View {
        VStack {
            VStack (alignment: .leading){
                Text("Visual Customization")
                    .font(.title2.bold())
                    .padding(.bottom, 2)
                
                Text("Customize the look and feel of your goal. Once your done, click complete to add your new goal!")
                    .font(.callout)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .opacity(isFocused ? 0 : 1)
            .frame(width: screenWidth*0.90)
            
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
                        
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                    }
                    
                }
                .offset(x: 0,y: -45)
                .frame(width: screenWidth*0.4*2)
                
                ProgressView(
                    goal: goal,
                    startNumber: exampleStarting,
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
            .offset(y: 10)
            
            VStack{
                ZStack{
                    if selectedPicker != 0 {
                        if goal.accentColor != goal.catagory?.color ?? .black || goal.backgroundColor != Color.gray || goal.displayTitle != "" {
                            ZStack{
                                RoundedRectangle(cornerRadius: 22)
                                    .frame(width: 100, height: 60, alignment: .bottom)
                                    .foregroundStyle(Color(UIColor.systemBackground))
                                    .foregroundStyle(.ultraThinMaterial)
                                
                                Text("Reset?")
                                    .bold()
                                    .offset(x: 0, y: -10)
                                    .foregroundColor(.accentColor)
                                
                            }
                            .offset(x: 0, y: 95)
                            .onTapGesture {
                                if selectedPicker == 1 {
                                    withAnimation(.easeOut) {
                                        goal.accentColor = goal.catagory?.color ?? .black
                                        goal.backgroundColor = Color.gray
                                    }
                                } else if selectedPicker == 2 {
                                    
                                } else if selectedPicker == 3 {
                                    withAnimation(.easeOut) {
                                        goal.displayTitle = ""
                                    }
                                }
                            }
                        }
                        
                        
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: screenWidth/1.15+6, height: 145, alignment: .bottom)
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .foregroundStyle(.ultraThinMaterial)
                        
                        RoundedRectangle(cornerRadius: 22)
                            .frame(width: screenWidth/1.15, height: 140, alignment: .bottom)
                            .foregroundStyle(Color(UIColor.systemBackground))
                            .foregroundStyle(.ultraThinMaterial)
                    }
                    
                    if selectedPicker == 1 {
                        HStack (spacing: 20){
                            VStack{
                                ZStack{
                                    RoundedRectangle(cornerRadius: 12)
                                        .frame (width: 140, height: 40, alignment: .center)
                                        .foregroundStyle(achieveStyleSimple)
                                    
                                    Text("Accent Color")
                                        .foregroundColor(Color(UIColor.systemBackground))
                                        .bold()
                                }
                                
                                ColorPicker("", selection: $goal.accentColor, supportsOpacity: false)
                                    .padding(.top, 10)
                                    .labelsHidden()
                                    .scaleEffect(1.5)
                            }
                            VStack{
                                ZStack{
                                    RoundedRectangle(cornerRadius: 12)
                                        .frame (width: 140, height: 40, alignment: .center)
                                        .foregroundStyle(achieveStyleSimple)
                                    
                                    Text("Backdrop Color")
                                        .foregroundColor(Color(UIColor.systemBackground))
                                        .bold()
                                }
                                
                                ColorPicker("", selection: $goal.backgroundColor, supportsOpacity: false)
                                    .padding(.top, 10)
                                    .labelsHidden()
                                    .scaleEffect(1.5)
                            }
                        }
                        .offset(x: 0, y: -5)
                    } else if selectedPicker == 2 {
                        Text("Icon Selector Coming Soon!")
                    } else if selectedPicker == 3 {
                        VStack{
                        
                            Text("Rename Title?")
                                .font(.title2.bold())
                                .offset(x: 0, y: -10)
                            
                        ZStack{
                            RoundedRectangle(cornerRadius: 100)
                                .frame(width: screenWidth/1.3+6, height: 45, alignment: .center)
                                .foregroundStyle(achieveStyleSimple)
                                .foregroundStyle(.ultraThinMaterial)
                                .offset(x: 0, y: -10)
                            
                            HStack{
                                
                                Text(Image(systemName: "highlighter"))
                                    .foregroundColor(.secondary)
                                
                                TextField("Title of your goal...", text: $goal.displayTitle)
                                    .onSubmit {
                                        let errorCheck = titleErrorCheck(goal.displayTitle)
                                        if errorCheck != "NI" {
                                            displayError = true
                                            errorText = errorCheck
                                        } else {
                                            displayError = false
                                        }
                                    }
                                    .submitLabel(.done)
                                    .frame(width: screenWidth/1.6, alignment: .trailing)
                                    .focused($isFocused)
                                    .keyboardType(.alphabet)
                                    .disableAutocorrection(true)
                                
                            }
                            .frame(width: screenWidth/1.3 ,height: 40, alignment: .center)
                            .background(Capsule().fill(Color(UIColor.systemBackground)))
                            .offset(x: 0, y: -10)
                            
                            Text("\(Image(systemName: "exclamationmark.circle.fill")) \(errorText)")
                                .font(.caption)
                                .foregroundColor(.red)
                                .opacity(displayError ? 1 : 0)
                                .offset(x: 0, y: 27)
                                .frame(width: screenWidth/1.3, alignment: .leading)
                            
                        }
                    }
                    }
                    
                }
                Spacer()
                HStack (spacing: 35) {
                    ZStack {
                        Circle()
                            .foregroundStyle (LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 70, height: 70)
                        
                        Circle()
                            .foregroundStyle (selectedPicker == 1 ? LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [Color(UIColor.systemBackground)], startPoint: .bottom, endPoint: .bottom))
                            .frame(width: 64, height: 64)
                        
                        Image(systemName: "paintpalette.fill")
                            .scaleEffect(2)
                            .foregroundStyle (selectedPicker != 1 ? LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [Color(UIColor.systemBackground)], startPoint: .bottom, endPoint: .bottom))
                        
                    }
                    .onTapGesture {
                        withAnimation(.easeIn) {selectedPicker = 1}
                    }
                    
                    ZStack {
                        Circle()
                            .foregroundStyle (LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 70, height: 70)
                        
                        Circle()
                            .foregroundStyle (selectedPicker == 2 ? LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [Color(UIColor.systemBackground)], startPoint: .bottom, endPoint: .bottom))
                            .frame(width: 64, height: 64)
                        
                        Image(systemName: "square.stack.3d.up.fill")
                            .scaleEffect(2.1)
                            .foregroundStyle (selectedPicker != 2 ? LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [Color(UIColor.systemBackground)], startPoint: .bottom, endPoint: .bottom))
                        
                    }
                    .onTapGesture {
                        withAnimation(.easeIn) { selectedPicker = 2 }
                    }
                    
                    ZStack {
                        Circle()
                            .foregroundStyle (LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 70, height: 70)
                        
                        Circle()
                            .foregroundStyle (selectedPicker == 3 ? LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [Color(UIColor.systemBackground)], startPoint: .bottom, endPoint: .bottom))
                            .frame(width: 64, height: 64)
                        
                        Image(systemName: "rectangle.and.pencil.and.ellipsis")
                            .scaleEffect(1.5)
                            .foregroundStyle (selectedPicker != 3 ? LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [Color(UIColor.systemBackground)], startPoint: .bottom, endPoint: .bottom))
                    }
                    .onTapGesture {
                        withAnimation(.easeIn) { selectedPicker = 3}
                    }
                }
            }
            .frame(height: 250)
            .offset(x: 0, y: 50)
            
            Button(action: {
                if displayError == false {
                    goal.state = .custom
                    goal.state = .active
                    screenInfo.activeGoalsArray.append(goal)
                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
                screenInfo.firstTime = false
                screenInfo.showWelcomeScreen = false
                    UITableView.appearance().backgroundColor = UIColor.systemGray6
                    
                    screenInfo.catagoryScores = catagoryPrecedence(screenInfo.activeGoalsArray)
                    screenInfo.progressionEnd = currentProgressTotal(screenInfo.activeGoalsArray)
                    screenInfo.progressionStart = currentProgressStart(screenInfo.activeGoalsArray)
                }
            }) {
                Text("Complete Goal")
                    .frame(width: screenWidth*0.425*2.125 - 100, height: 40)
                    .background (LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .foregroundColor(Color(UIColor.systemBackground))
                    .cornerRadius(40)
                    .font(.body.bold())
                    .padding(.bottom)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea(.keyboard)
        }
        
        .navigationBarItems(trailing:
                                Button(action: {
            UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
        }) {
            Text("Cancel")
        })
        .preferredColorScheme(screenInfo.darkMode ? .dark : .light)
    }
}

struct CustomizeCreateView_Previews: PreviewProvider {
    static let goalInfo = Goal()
    static let screenInfo = goalScreenInfo()
    static var previews: some View {
        NavigationView {
            CustomizeCreateView()
        }
        .environmentObject(goalInfo)
        .environmentObject(screenInfo)
    }
}
