//
//  SpecificationsView.swift
//  Achieve
//
//  Created by swift on 2022-07-25.
//

import SwiftUI

struct SpecificationsCreateView: View {
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    let screenSize = UIScreen.main.bounds.size
    
    @EnvironmentObject var goalInfo: newGoalInfo
    @EnvironmentObject var screenInfo: goalScreenInfo
        
    @State var uiUpdate = false
    @State var sendNextView = false
    
    @FocusState private var keyboardActive: Bool
    
    func isWhole (_ amount:String, _ inc:String) -> Bool {
        
        let newAmount = Double(amount)
        let newInc = Double(inc)
        
        let divided = newAmount!/newInc!
        if divided.truncatingRemainder(dividingBy: 1) == 0 {
            return true
        } else {
            return false
        }
    }
    
    func updateSche (_ scheType:Int) -> String {
        if scheType == 1 {
            return "Days"
        } else if scheType == 2 {
            return "Weeks"
        } else {
            return "Months"
        }
    }
    
    @State var timeError1 = ""
    @State var timeError2 = ""
    
    @State var amountError1 = ""
    @State var amountError2 = ""
    
    @State var timeError1Selected = false
    @State var timeError2Selected = false
    
    @State var amountError1Selected = false
    @State var amountError2Selected = false
    
    @State var mainError = ""
    @State var mainErrorSelected = false
    
    @State var noDrag = false
    
    func mainErrorCheck() {
        if goalInfo.goalSpecs.selfDirected == true {
            return
        }
        if goalInfo.selectedPicker == 0 {
            mainError = "Click the buttons above to add specifications"
            mainErrorSelected = true
            return
        }
        if goalInfo.goalSpecs.selectedTimeSpec == -1 {
            mainError = "Please select a time specification"
            mainErrorSelected = true
            return
        }
        if goalInfo.goalSpecs.selectedAmountSpec == -1 {
            mainError = "Please select an amount specification"
            mainErrorSelected = true
            return
        }
    }
    
    func errorCheck() {
        
        withAnimation(.easeOut) {
            timeError1Selected = false
            timeError2Selected = false
            
            amountError1Selected = false
            amountError2Selected = false
        }
        
        if goalInfo.goalSpecs.selectedTimeSpec == 1 {
            if goalInfo.goalSpecs.scheduleType == -1 {
                timeError1 = "Please select a schedule"
                timeError1Selected = true
            } else if goalInfo.goalSpecs.durationSpec == -1 {
                timeError1 = "Please select a duration"
                timeError1Selected = true
            } else if goalInfo.goalSpecs.durationSpec == 1 && goalInfo.goalSpecs.durationAmount == "" {
                timeError1 = "Please specify how long the goal should last for"
                timeError1Selected = true
            } else if goalInfo.goalSpecs.durationSpec == 1 && goalInfo.goalSpecs.durationAmount != "" && onlyNumbers(goalInfo.goalSpecs.durationAmount) == false {
                timeError1 = "Please enter a number for duration length"
                timeError1Selected = true
            }
        } else if goalInfo.goalSpecs.selectedTimeSpec == 2 {
            
            let calendar = Calendar.current
            let goalDate = calendar.startOfDay(for: goalInfo.goalSpecs.finishDate)
            let today = calendar.startOfDay(for: Date.now)
            let components = calendar.dateComponents([.day], from: today, to: goalDate)
            if components.day! <= 1 {
                timeError2 = "Please select a valid date"
                timeError2Selected = true
            }
        }
        
        if goalInfo.goalSpecs.selectedAmountSpec == 1 {
            if goalInfo.goalSpecs.goalAmount == "" {
                amountError1 = "Please specify the goal's amount"
                amountError1Selected = true
            } else if onlyNumbers(goalInfo.goalSpecs.goalAmount) == false {
                amountError1 = "Please enter a number for goal amount"
                amountError1Selected = true
            } else if goalInfo.goalSpecs.isGoalIncrement == -1 {
                amountError1 = "Please enter a specification for the increment"
                amountError1Selected = true
            } else if goalInfo.goalSpecs.isGoalIncrement == 1 && goalInfo.goalSpecs.goalIncrement == "" {
                amountError1 = "Please enter a goal increment"
                amountError1Selected = true
            } else if goalInfo.goalSpecs.isGoalIncrement == 1 && goalInfo.goalSpecs.goalIncrement != "" && onlyNumbers(goalInfo.goalSpecs.goalIncrement) == false {
                amountError1 = "Please enter a number for goal increment"
                amountError1Selected = true
            } else if onlyNumbers(goalInfo.goalSpecs.goalIncrement) == true && onlyNumbers(goalInfo.goalSpecs.goalIncrement) == true && goalInfo.goalSpecs.isGoalIncrement == 1{
                if isWhole(goalInfo.goalSpecs.goalAmount, goalInfo.goalSpecs.goalIncrement) == false {
                amountError1 = "Goal increment must be a divisor of the amount"
                amountError1Selected = true
                }
            }
        } else if goalInfo.goalSpecs.selectedAmountSpec == 2 {
            if goalInfo.goalSpecs.amountDurationType == -1 {
                amountError2 = "Please enter a duration type"
                amountError2Selected = true
            } else if goalInfo.goalSpecs.amountDurationType != -1 && goalInfo.goalSpecs.amountDurationAmount == ""{
                amountError2 = "Please enter a duration amount"
                amountError2Selected = true
            } else if goalInfo.goalSpecs.amountDurationType != -1 && goalInfo.goalSpecs.amountDurationAmount != "" && onlyNumbers(goalInfo.goalSpecs.amountDurationAmount) == false {
                
                amountError2 = "Please enter a number for duration amount"
                amountError2Selected = true
            } else if onlyNumbers(goalInfo.goalSpecs.amountDurationAmount) == false {
                if goalInfo.goalSpecs.amountDurationType == 1 && Int(goalInfo.goalSpecs.amountDurationAmount)! > 60 {
                    amountError2 = "Please enter a valid duration amount"
                    amountError2Selected = true
                }
                if goalInfo.goalSpecs.amountDurationType == 2 && Int(goalInfo.goalSpecs.amountDurationAmount)! > 12 {
                    amountError2 = "Please enter a valid duration amount"
                    amountError2Selected = true
                }
                if goalInfo.goalSpecs.amountDurationType == 3 && Int(goalInfo.goalSpecs.amountDurationAmount)! > 4 {
                    amountError2 = "Please enter a valid duration amount"
                    amountError2Selected = true
                }
            }
        }
        if goalInfo.goalSpecs.selfDirected == true {
            timeError1 = ""
            timeError2 = ""
            
            amountError1 = ""
            amountError2 = ""
            
            timeError1Selected = false
            timeError2Selected = false
            
            amountError1Selected = false
            amountError2Selected = false
        }
    }
    
    var body: some View {
        ZStack{
            VStack {
                VStack (alignment: .leading){
                    Text("Goal Specifications")
                        .font(.title2.bold())
                        .padding(.bottom, 2)
                    
                    Text("Deside on the goals time and count aspects or select self desided goal to handle it your way.")
                        .font(.callout)
                        .padding(.bottom, 10)
                        .fixedSize(horizontal: false, vertical: true)
                    
                }
                .opacity(keyboardActive ? 0 : 1)
                
                HStack (spacing: 35) {
                    ZStack {
                        Circle()
                            .foregroundStyle (LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 70, height: 70)
                        
                        Circle()
                            .foregroundStyle (goalInfo.selectedPicker == 1 ? LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [Color(UIColor.systemBackground)], startPoint: .bottom, endPoint: .bottom))
                            .frame(width: 64, height: 64)
                        
                        Image(systemName: "clock.fill")
                            .scaleEffect(2)
                            .foregroundStyle (goalInfo.selectedPicker != 1 ? LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [Color(UIColor.systemBackground)], startPoint: .bottom, endPoint: .bottom))
                        
                        Circle()
                            .foregroundColor(.black)
                            .frame(width: 70, height: 70)
                            .opacity(goalInfo.goalSpecs.selfDirected ? 0.2 : 0)
                        
                        if timeError1Selected || timeError2Selected {
                            
                            ZStack{
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color(UIColor.systemBackground))
                                    .offset(x: 30, y: -30)
                                
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                                    .scaleEffect(1.1)
                                    .offset(x: 30, y: -30)
                            }
                        }
                        
                    }
                    .onTapGesture {
                        withAnimation(.easeIn) { goalInfo.selectedPicker = 1}
                        withAnimation(.easeIn) { goalInfo.goalSpecs.selfDirected = false}
                        withAnimation(.easeOut) { mainErrorSelected = false }
                    }
                    
                    ZStack {
                        Circle()
                            .foregroundStyle (LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 70, height: 70)
                        
                        Circle()
                            .foregroundStyle (goalInfo.selectedPicker == 2 ? LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [Color(UIColor.systemBackground)], startPoint: .bottom, endPoint: .bottom))
                            .frame(width: 64, height: 64)
                        
                        Image(systemName: "number.circle.fill")
                            .scaleEffect(2.5)
                            .foregroundStyle (goalInfo.selectedPicker != 2 ? LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [Color(UIColor.systemBackground)], startPoint: .bottom, endPoint: .bottom))
                        
                        Circle()
                            .foregroundColor(.black)
                            .frame(width: 70, height: 70)
                            .opacity(goalInfo.goalSpecs.selfDirected ? 0.2 : 0)
                        
                        if amountError1Selected || amountError2Selected {
                            
                            ZStack{
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color(UIColor.systemBackground))
                                    .offset(x: 30, y: -30)
                                
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                                    .scaleEffect(1.1)
                                    .offset(x: 30, y: -30)
                                
                            }
                        }
                        
                    }
                    .onTapGesture {
                        withAnimation(.easeIn) { goalInfo.selectedPicker = 2 }
                        withAnimation(.easeIn) { goalInfo.goalSpecs.selfDirected = false}
                        withAnimation(.easeOut) { mainErrorSelected = false }
                    }
                    
                    ZStack {
                        Circle()
                            .foregroundStyle (LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 70, height: 70)
                        
                        Circle()
                            .foregroundStyle (goalInfo.selectedPicker == 3 ? LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [Color(UIColor.systemBackground)], startPoint: .bottom, endPoint: .bottom))
                            .frame(width: 64, height: 64)
                        
                        Image(systemName: "person.crop.circle.fill.badge.checkmark")
                            .scaleEffect(2.2)
                            .foregroundStyle (goalInfo.selectedPicker != 3 ? LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [Color(UIColor.systemBackground)], startPoint: .bottom, endPoint: .bottom))
                    }
                    .onTapGesture {
                        withAnimation(.easeIn) { goalInfo.selectedPicker = 3}
                        withAnimation(.easeIn) { goalInfo.goalSpecs.selfDirected = true}
                        withAnimation(.easeOut) { mainErrorSelected = false }
                        errorCheck()
                    }
                }
                .padding(.bottom)
                
                ZStack {
                    
                    if goalInfo.selectedPicker != 0 {
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: screenWidth/1.15+6, height: 355, alignment: .bottom)
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .foregroundStyle(.ultraThinMaterial)
                        
                        RoundedRectangle(cornerRadius: 22)
                            .frame(width: screenWidth/1.15, height: 350, alignment: .bottom)
                            .foregroundStyle(Color(UIColor.systemBackground))
                            .foregroundStyle(.ultraThinMaterial)
                    }
                    
                    if goalInfo.selectedPicker == 1 {
                        
                        Text("Time Settings")
                            .font(.title2.bold())
                            .offset(x: 0, y: -145)
                        
                        ZStack{
                            
                            Form{
                                ScrollView (showsIndicators: false){
                                    Section {
                                        HStack {
                                            VStack (alignment: .leading){
                                                Text("\nScheduled Goal")
                                                Text("Allows you to set goals to repeat").font(.caption)
                                            }
                                            
                                            Spacer()
                                            
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 10)
                                                    .frame(width: 35, height: 35)
                                                    .offset(x: -10, y: 10)
                                                    .foregroundStyle(achieveStyleSimple)
                                                
                                                RoundedRectangle(cornerRadius: 8)
                                                    .frame(width: 30, height: 30)
                                                    .offset(x: -10, y: 10)
                                                    .foregroundStyle(goalInfo.goalSpecs.selectedTimeSpec == 1 ? achieveStyleSimple : achieveStyleWhite)
                                                
                                                Text("\(Image(systemName: "checkmark"))")
                                                    .bold()
                                                    .font(.title3)
                                                    .offset(x: -10, y: 9)
                                                    .foregroundColor(Color(UIColor.systemBackground))
                                                    .opacity(goalInfo.goalSpecs.selectedTimeSpec == 1 ? 1 : 0)
                                                
                                                RoundedRectangle(cornerRadius: 10)
                                                    .frame(width: 35, height: 35)
                                                    .offset(x: -10, y: 10)
                                                    .opacity(0.0001)
                                                    .onTapGesture{
                                                        goalInfo.goalSpecs.selectedTimeSpec = 1
                                                        withAnimation(.easeIn) {uiUpdate.toggle()}
                                                        mainErrorSelected = false
                                                    }
                                            }
                                        }
                                        HStack {
                                            VStack (alignment: .leading){
                                                Text("Countdown Goal")
                                                Text("Allows you to set a finish date").font(.caption)
                                            }
                                            
                                            Spacer()
                                            
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 10)
                                                    .frame(width: 35, height: 35)
                                                    .offset(x: -10, y: 0)
                                                    .foregroundStyle(achieveStyleSimple)
                                                
                                                RoundedRectangle(cornerRadius: 8)
                                                    .frame(width: 30, height: 30)
                                                    .offset(x: -10, y: 0)
                                                    .foregroundStyle(goalInfo.goalSpecs.selectedTimeSpec == 2 ? achieveStyleSimple : achieveStyleWhite)
                                                
                                                Text("\(Image(systemName: "checkmark"))")
                                                    .bold()
                                                    .font(.title3)
                                                    .offset(x: -10, y: -1)
                                                    .foregroundColor(Color(UIColor.systemBackground))
                                                    .opacity(goalInfo.goalSpecs.selectedTimeSpec == 2 ? 1 : 0)
                                                
                                                RoundedRectangle(cornerRadius: 10)
                                                    .frame(width: 35, height: 35)
                                                    .offset(x: -10, y: 10)
                                                    .opacity(0.0001)
                                                    .onTapGesture{
                                                        goalInfo.goalSpecs.selectedTimeSpec = 2
                                                        withAnimation(.easeIn) {uiUpdate.toggle()}
                                                        mainErrorSelected = false
                                                    }
                                            }
                                            
                                        }
                                        HStack {
                                            VStack (alignment: .leading){
                                                Text("One-Time Goal")
                                                Text("Goal has no specified timeframe").font(.caption)
                                            }
                                            
                                            Spacer()
                                            
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 10)
                                                    .frame(width: 35, height: 35)
                                                    .offset(x: -10, y: 0)
                                                    .foregroundStyle(achieveStyleSimple)
                                                
                                                RoundedRectangle(cornerRadius: 8)
                                                    .frame(width: 30, height: 30)
                                                    .offset(x: -10, y: 0)
                                                    .foregroundStyle(goalInfo.goalSpecs.selectedTimeSpec == 3 ? achieveStyleSimple : achieveStyleWhite)
                                                
                                                Text("\(Image(systemName: "checkmark"))")
                                                    .bold()
                                                    .font(.title3)
                                                    .offset(x: -10, y: -1)
                                                    .foregroundColor(Color(UIColor.systemBackground))
                                                    .opacity(goalInfo.goalSpecs.selectedTimeSpec == 3 ? 1 : 0)
                                                
                                                RoundedRectangle(cornerRadius: 10)
                                                    .frame(width: 35, height: 35)
                                                    .offset(x: -10, y: 10)
                                                    .opacity(0.0001)
                                                    .onTapGesture{
                                                        goalInfo.goalSpecs.selectedTimeSpec = 3
                                                        withAnimation(.easeIn) {uiUpdate.toggle()}
                                                        mainErrorSelected = false
                                                    }
                                            }
                                            
                                        }
                                    }
                                    if goalInfo.goalSpecs.selectedTimeSpec == 1 {
                                        Section (header: Text("\nScheduled Goal Settings").font(.caption).offset(x: -70)){
                                            HStack {
                                                Text("Schedule: ")
                                                
                                                Picker("", selection: $goalInfo.goalSpecs.scheduleType) {
                                                    Text("Daily")
                                                        .tag(1)
                                                    Text("Weekly")
                                                        .tag(2)
                                                    Text("Monthly")
                                                        .tag(3)
                                                }
                                                .pickerStyle(SegmentedPickerStyle())
                                                
                                            }
                                            HStack {
                                                Text("Duration: ")
                                                
                                                Spacer()
                                                
                                                Picker("sType", selection: $goalInfo.goalSpecs.durationSpec) {
                                                    Text("Specified")
                                                        .tag(1)
                                                    Text("Non-Specified")
                                                        .tag(2)
                                                }
                                                .pickerStyle(SegmentedPickerStyle())
                                                .frame(width:212)
                                                .onSubmit({errorCheck()})
                                                
                                            }
                                            if goalInfo.goalSpecs.durationSpec == 1 && goalInfo.goalSpecs.scheduleType != -1{
                                                HStack {
                                                    Text("Continue for:")
                                                    
                                                    Spacer()
                                                    
                                                    TextField("# of", text: $goalInfo.goalSpecs.durationAmount)
                                                        .keyboardType(.numberPad)
                                                        .frame(width: 50)
                                                        .multilineTextAlignment(.trailing)
                                                        .focused($keyboardActive)
                                                    
                                                    Text(updateSche(goalInfo.goalSpecs.scheduleType))
                                                    
                                                }
                                            }
                                            if timeError1Selected {
                                                Text("\(Image(systemName: "exclamationmark.circle.fill")) \(timeError1)\n")
                                                    .font(.caption)
                                                    .foregroundColor(.red)
                                                    .frame(width: 300, alignment: .leading)
                                                    .tag("timeError1")
                                            }
                                            
                                            Text("")
                                        }
                                    } else if goalInfo.goalSpecs.selectedTimeSpec == 2 {
                                        
                                        Section (header: Text("\nCountdown Goal Settings").font(.caption).offset(x: -68, y: 5)){
                                            
                                            DatePicker(selection: $goalInfo.goalSpecs.finishDate, in: Date()..., displayedComponents: .date) {
                                                Text("Finish Date")
                                            }
                                            
                                            HStack{
                                                Text("Starting Today?")
                                                
                                                Spacer()
                                                
                                                Toggle("", isOn: $goalInfo.goalSpecs.startingToday)
                                                    .labelsHidden()
                                                    .tint(.accentColor)
                                                    .offset(x: -1)
                                            }
                                            
                                            if timeError2Selected {
                                                Text("\(Image(systemName: "exclamationmark.circle.fill")) \(timeError2)\n")
                                                    .font(.caption)
                                                    .foregroundColor(.red)
                                                    .frame(width: 300, alignment: .leading)
                                            }
                                            
                                            Text("")
                                        }
                                    }
                                }
                                .background(Color(UIColor.systemBackground))
                                .frame(width:300, height: 276, alignment: .top)
                                .offset(x:-20)
                            }
                            .onAppear{
                                UITableView.appearance().backgroundColor = .clear
                            }
                            .frame(width: 340)
                            
                            Rectangle()
                                .frame(width: 300, height: 25, alignment: .center)
                                .mask(LinearGradient(colors: [Color(UIColor.systemBackground),.clear], startPoint: .top, endPoint: .bottom))
                                .foregroundColor(Color(UIColor.systemBackground))
                                .offset(x: 0, y: -130)
                            
                            Rectangle()
                                .frame(width: 300, height: 25, alignment: .center)
                                .mask(LinearGradient(colors: [.clear,Color(UIColor.systemBackground)], startPoint: .top, endPoint: .bottom))
                                .foregroundColor(Color(UIColor.systemBackground))
                                .offset(x: 0, y: 135)
                            
                            ZStack{
                                Rectangle()
                                    .frame(width: screenWidth, height: 35, alignment: .center)
                                    .foregroundColor(Color(UIColor.systemBackground))
                                    .offset(x: 0, y: 160)
                                
                                Rectangle()
                                    .frame(width: screenWidth, height: 35, alignment: .center)
                                    .foregroundColor(Color(UIColor.systemBackground))
                                    .offset(x: 0, y: -160)
                                
                                Rectangle()
                                    .frame(width: 35, height: screenWidth-100, alignment: .center)
                                    .foregroundColor(Color(UIColor.systemBackground))
                                    .offset(x: 167)
                                
                                Rectangle()
                                    .frame(width: 35, height: screenWidth-100, alignment: .center)
                                    .foregroundColor(Color(UIColor.systemBackground))
                                    .offset(x: -167)
                                }
                            .opacity(0.02)
                        }
                        .offset(x: 0, y: 20)
                        
                    } else if goalInfo.selectedPicker == 2 {
                        
                        Text("Count Settings")
                            .font(.title2.bold())
                            .offset(x: 0, y: -145)
                        
                        ZStack{
                            
                            Form{
                                ScrollView (showsIndicators: false){
                                    
                                    Section {
                                        
                                        HStack {
                                            VStack (alignment: .leading){
                                                Text("\nQuantity Based")
                                                Text("Do something a certain amount of times").font(.caption)
                                            }
                                            
                                            Spacer()
                                            
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 10)
                                                    .frame(width: 35, height: 35)
                                                    .offset(x: -10, y: 10)
                                                    .foregroundStyle(achieveStyleSimple)
                                                
                                                RoundedRectangle(cornerRadius: 8)
                                                    .frame(width: 30, height: 30)
                                                    .offset(x: -10, y: 10)
                                                    .foregroundStyle(goalInfo.goalSpecs.selectedAmountSpec == 1 ? achieveStyleSimple : achieveStyleWhite)
                                                
                                                Text("\(Image(systemName: "checkmark"))")
                                                    .bold()
                                                    .font(.title3)
                                                    .offset(x: -10, y: 9)
                                                    .foregroundColor(Color(UIColor.systemBackground))
                                                    .opacity(goalInfo.goalSpecs.selectedAmountSpec == 1 ? 1 : 0)
                                                
                                                RoundedRectangle(cornerRadius: 10)
                                                    .frame(width: 35, height: 35)
                                                    .offset(x: -10, y: 10)
                                                    .opacity(0.0001)
                                                    .onTapGesture{
                                                        goalInfo.goalSpecs.selectedAmountSpec = 1
                                                        withAnimation(.easeIn) {uiUpdate.toggle()}
                                                        mainErrorSelected = false
                                                    }
                                            }
                                            
                                        }
                                        HStack {
                                            VStack (alignment: .leading){
                                                Text("Time Based")
                                                Text("Do somthing for a certain duration of time").font(.caption)
                                            }
                                            
                                            Spacer()
                                            
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 10)
                                                    .frame(width: 35, height: 35)
                                                    .offset(x: -10, y: 0)
                                                    .foregroundStyle(achieveStyleSimple)
                                                
                                                RoundedRectangle(cornerRadius: 8)
                                                    .frame(width: 30, height: 30)
                                                    .offset(x: -10, y: 0)
                                                    .foregroundStyle( goalInfo.goalSpecs.selectedAmountSpec == 2 ? achieveStyleSimple : achieveStyleWhite)
                                                
                                                Text("\(Image(systemName: "checkmark"))")
                                                    .bold()
                                                    .font(.title3)
                                                    .offset(x: -10, y: -1)
                                                    .foregroundColor(Color(UIColor.systemBackground))
                                                    .opacity( goalInfo.goalSpecs.selectedAmountSpec == 2 ? 1 : 0)
                                                
                                                RoundedRectangle(cornerRadius: 10)
                                                    .frame(width: 35, height: 35)
                                                    .offset(x: -10, y: 10)
                                                    .opacity(0.0001)
                                                    .onTapGesture{
                                                        goalInfo.goalSpecs.selectedAmountSpec = 2
                                                        withAnimation(.easeIn) {uiUpdate.toggle()}
                                                        mainErrorSelected = false
                                                    }
                                            }
                                            
                                        }
                                        HStack {
                                            VStack (alignment: .leading){
                                                Text("Self Desided")
                                                Text("You deside when you are done").font(.caption)
                                            }
                                            
                                            Spacer()
                                            
                                            ZStack{
                                                
                                                RoundedRectangle(cornerRadius: 10)
                                                    .frame(width: 35, height: 35)
                                                    .offset(x: -10, y: 0)
                                                    .foregroundStyle(achieveStyleSimple)
                                                
                                                RoundedRectangle(cornerRadius: 8)
                                                    .frame(width: 30, height: 30)
                                                    .offset(x: -10, y: 0)
                                                    .foregroundStyle( goalInfo.goalSpecs.selectedAmountSpec == 3 ? achieveStyleSimple : achieveStyleWhite)
                                                
                                                Text("\(Image(systemName: "checkmark"))")
                                                    .bold()
                                                    .font(.title3)
                                                    .offset(x: -10, y: -1)
                                                    .foregroundColor(Color(UIColor.systemBackground))
                                                    .opacity( goalInfo.goalSpecs.selectedAmountSpec == 3 ? 1 : 0)
                                                
                                                RoundedRectangle(cornerRadius: 10)
                                                    .frame(width: 35, height: 35)
                                                    .offset(x: -10, y: 10)
                                                    .opacity(0.0001)
                                                    .onTapGesture{
                                                        goalInfo.goalSpecs.selectedAmountSpec = 3
                                                        withAnimation(.easeIn) {uiUpdate.toggle()}
                                                        mainErrorSelected = false
                                                    }
                                            }
                                            
                                        }
                                    }
                                    if goalInfo.goalSpecs.selectedAmountSpec == 1 {
                                        Section (header: Text("\nQuantity Based Settings").font(.caption).offset(x: -74)){
                                            
                                            HStack {
                                                Text("Goal Objective Amount:")
                                                Spacer()
                                                TextField("Amount", text: $goalInfo.goalSpecs.goalAmount)
                                                    .keyboardType(.numberPad)
                                                    .frame(width: 100)
                                                    .multilineTextAlignment(.trailing)
                                                    .focused($keyboardActive)
                                            }
                                            HStack{
                                                Text("Increment:")
                                                
                                                Spacer()
                                                
                                                Picker("sType", selection: $goalInfo.goalSpecs.isGoalIncrement) {
                                                    Text("Specified")
                                                        .tag(1)
                                                    Text("Non-Specified")
                                                        .tag(2)
                                                }
                                                .pickerStyle(SegmentedPickerStyle())
                                                .frame(width:202)
                                            }
                                            Text("Should the amount be broken up into groups?").font(.caption)
                                                .multilineTextAlignment(.leading)
                                            
                                            if goalInfo.goalSpecs.isGoalIncrement == 1 && goalInfo.goalSpecs.goalAmount != "" {
                                                
                                                HStack {
                                                    VStack(alignment: .leading){
                                                        Text("Increment Amount:")
                                                        
                                                    }
                                                    Spacer()
                                                    TextField("Amount", text: $goalInfo.goalSpecs.goalIncrement)
                                                        .keyboardType(.numberPad)
                                                        .frame(width: 100)
                                                        .multilineTextAlignment(.trailing)
                                                        .focused($keyboardActive)
                                                }
                                                Text("ie. 200 / increment of 10 = 20 groups ").font(.caption)
                                                    .multilineTextAlignment(.leading)
                                                    .padding(.bottom, 1)
                                            }
                                            if amountError1Selected {
                                                Text("\n\(Image(systemName: "exclamationmark.circle.fill")) \(amountError1)\n")
                                                    .font(.caption)
                                                    .foregroundColor(.red)
                                                    .frame(width: 300, alignment: .leading)
                                            }
                                            
                                            Text("")
                                                .tag("bottomAmount1")
                                            
                                        }
                                    } else if goalInfo.goalSpecs.selectedAmountSpec == 2 {
                                        
                                        Section (header: Text("\nTime Based Settings").font(.caption).offset(x: -82, y: 5)){
                                            HStack{
                                                VStack(alignment:.leading){
                                                    Text("Duration Type:")
                                                    if goalInfo.goalSpecs.scheduleType == 1 {
                                                        Text("Per day").font(.caption)
                                                    } else if goalInfo.goalSpecs.scheduleType == 2 {
                                                        Text("Per week").font(.caption)
                                                    } else if goalInfo.goalSpecs.scheduleType == 3 {
                                                        Text("Per month").font(.caption)
                                                    } else {
                                                        Text("Per day").font(.caption)
                                                    }
                                                }
                                                
                                                Spacer()
                                                
                                                Picker("sType", selection: $goalInfo.goalSpecs.amountDurationType) {
                                                    Text("Minutes")
                                                        .tag(1)
                                                    Text("Hours")
                                                        .tag(2)
                                                    if goalInfo.goalSpecs.scheduleType == 2 || goalInfo.goalSpecs.scheduleType == 3{
                                                        Text("Days")
                                                            .tag(3)
                                                    }
                                                }
                                                .pickerStyle(SegmentedPickerStyle())
                                            }
                                            if goalInfo.goalSpecs.amountDurationType != -1 {
                                                HStack{
                                                    if goalInfo.goalSpecs.amountDurationType == 1{
                                                        Text("Amount of Minutes:")
                                                    } else if  goalInfo.goalSpecs.amountDurationType == 2 {
                                                        Text("Amount of Hours:")
                                                    } else if goalInfo.goalSpecs.amountDurationType == 3 {
                                                        Text("Amount of Weeks:")
                                                    }
                                                    
                                                    Spacer()
                                                    
                                                    TextField("Amount", text: $goalInfo.goalSpecs.amountDurationAmount)
                                                        .keyboardType(.numberPad)
                                                        .frame(width: 100)
                                                        .multilineTextAlignment(.trailing)
                                                        .focused($keyboardActive)
                                                }
                                            }
                                            if amountError2Selected {
                                                Text("\(Image(systemName: "exclamationmark.circle.fill")) \(amountError2)\n")
                                                    .font(.caption)
                                                    .foregroundColor(.red)
                                                    .frame(width: 300, alignment: .leading)
                                            }
                                            
                                            Text("")
                                                .tag("bottomAmount2")
                                        }
                                    }
                                    
                                    
                                }
                                .background(Color(UIColor.systemBackground))
                                .frame(width:300, height: 276, alignment: .center)
                                .offset(x:-20)
                            }
                            .onAppear{
                                UITableView.appearance().backgroundColor = .clear
                            }
                            .frame(width: 340)
                            
                            Rectangle()
                                .frame(width: 300, height: 25, alignment: .center)
                                .mask(LinearGradient(colors: [Color(UIColor.systemBackground),.clear], startPoint: .top, endPoint: .bottom))
                                .foregroundColor(Color(UIColor.systemBackground))
                                .offset(x: 0, y: -130)
                            
                            Rectangle()
                                .frame(width: 300, height: 25, alignment: .center)
                                .mask(LinearGradient(colors: [.clear,Color(UIColor.systemBackground)], startPoint: .top, endPoint: .bottom))
                                .foregroundColor(Color(UIColor.systemBackground))
                                .offset(x: 0, y: 135)
                            
                            ZStack{
                                Rectangle()
                                    .frame(width: screenWidth, height: 35, alignment: .center)
                                    .foregroundColor(Color(UIColor.systemBackground))
                                    .offset(x: 0, y: 160)
                                
                                Rectangle()
                                    .frame(width: screenWidth, height: 35, alignment: .center)
                                    .foregroundColor(Color(UIColor.systemBackground))
                                    .offset(x: 0, y: -160)
                                
                                Rectangle()
                                    .frame(width: 35, height: screenWidth-100, alignment: .center)
                                    .foregroundColor(Color(UIColor.systemBackground))
                                    .offset(x: 167)
                                
                                Rectangle()
                                    .frame(width: 35, height: screenWidth-100, alignment: .center)
                                    .foregroundColor(Color(UIColor.systemBackground))
                                    .offset(x: -167)
                                }
                            .opacity(0.02)
                            
                        }
                        .offset(x: 0, y: 20)
                        
                    } else if goalInfo.selectedPicker == 3 {
                        
                        Text("Self Directed Goal")
                            .font(.title2.bold())
                            .offset(x: 0, y: -145)
                        
                        Text("By selecting this choice, you will be in charge and deside when the goal is done. \n\nSometimes the simplest goals are best!")
                            .font(.callout)
                            .offset(x: 0, y: -75)
                            .frame(width: 320)
                            .multilineTextAlignment(.leading)
                        
                        Circle()
                            .frame(width: 130, height: 130)
                            .offset(x: 0, y: 65)
                            .foregroundStyle(achieveStyleSimple)
                        
                        Image(systemName:("person.crop.circle.badge.checkmark"))
                            .scaleEffect(3.5)
                            .foregroundColor(Color(UIColor.systemBackground))
                            .offset(y: 58)
                        
                    }
                    
                    if mainErrorSelected {
                        Text("\(Image(systemName: "exclamationmark.circle.fill")) \(mainError)\n")
                            .font(.caption)
                            .foregroundColor(.red)
                            .frame(width: 340, alignment: .leading)
                            .offset(y: goalInfo.selectedPicker == 0 ? 365 : 200)
                    }
                    
                }
                
                Button(action: {
                    mainErrorCheck()
                    errorCheck()
                    
                    goalInfo.accentColor = goalInfo.catagory?.color ?? .black
                    
                    if timeError1Selected == false && timeError2Selected == false && amountError1Selected == false && amountError2Selected == false && mainErrorSelected == false {
                        sendNextView = true
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
                .frame(maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea(.keyboard)
            }
            .ignoresSafeArea(.keyboard)
            .frame(width: screenWidth*0.90)
            
            .navigationBarItems(trailing:
                                    Button(action: {
                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
            }) {
                Text("Cancel")
            })
            
            Rectangle()
                .ignoresSafeArea()
                .opacity(keyboardActive ? 0.001 : 0)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    if timeError1Selected == true || timeError2Selected == true || amountError1Selected == true || amountError2Selected == true {
                        errorCheck()
                    }
                }
        }
        .background(
            NavigationLink(
                destination: CustomizeCreateView(),
                isActive: $sendNextView,
                label: { EmptyView() })
        )
        .preferredColorScheme(screenInfo.darkMode ? .dark : .light)
    }
}

struct SpecificationsView_Previews: PreviewProvider {
    static let goalInfo = newGoalInfo()
    static let screenInfo = goalScreenInfo()
    static var previews: some View {
        NavigationView {
            SpecificationsCreateView()
        }
        .environmentObject(goalInfo)
        .environmentObject(screenInfo)
    }
}
