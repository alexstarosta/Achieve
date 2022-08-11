//
//  GoalsView.swift
//  Achieve
//
//  Created by swift on 2022-07-22.
//

import SwiftUI

func currentProgressTotal (_ activeGoals:[Goal] ) -> Double{
    var total: Double = 0
    for goal in activeGoals {
        if whatAmount(goal) != -1 {
            total += Double(whatAmount(goal))
        }
    }
    return total
}

func currentProgressStart (_ activeGoals:[Goal] ) -> Double {
    var total: Double = 0
    for goal in activeGoals {
        if whatAmount(goal) != -1 {
            total += Double(goal.extras.startingNum)
        }
    }
    return total
}

func catagoryPrecedence(_ activeGoals:[Goal]) -> [Double] {
    var healthScore:Double = 0, educationScore:Double = 0, financialScore:Double = 0, personalScore:Double = 0, socialScore:Double = 0, lifestyleScore:Double = 0, othercatScore:Double = 0
    
    for goal in activeGoals {
        switch goal.catagory {
            case .health:
                healthScore += 1
            case .education:
                educationScore += 1
            case .financial:
                financialScore += 1
            case .personal:
                personalScore += 1
            case .social:
                socialScore += 1
            case .lifestyle:
                lifestyleScore += 1
            case .othercat:
                othercatScore += 1
            default:
                continue
        }
    }
    
    let totalGoals = Double(activeGoals.count)
    
    return [healthScore/totalGoals, educationScore/totalGoals, financialScore/totalGoals, personalScore/totalGoals, socialScore/totalGoals, lifestyleScore/totalGoals, othercatScore/totalGoals]
}

struct GoalsView: View {
    
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var localUserData: LocalUserData

    @State var showingCreateSequence = false
    
    @State var goalOrder = "Oldest Goals"
    
    func reOrderGoals(_ type:GoalOrder){
        switch type {
        case .oldNew:
            withAnimation(.spring()){
                userData.activeGoalsArray = userData.activeGoalsArray.sorted(by: {$0.goalTimeID < $1.goalTimeID})
            }
                goalOrder = "Oldest Goals"
        case .newOld:
            withAnimation(.spring()){
                userData.activeGoalsArray = userData.activeGoalsArray.sorted(by: {$0.goalTimeID > $1.goalTimeID})
            }
                goalOrder = "Newest Goals"
        case .catagory:
            withAnimation(.spring()){
                userData.activeGoalsArray = userData.activeGoalsArray.sorted(by: {$0.catagory!.value < $1.catagory!.value})
            }
                goalOrder = "Goal Catagory"
        case .type:
            withAnimation(.spring()){
                userData.activeGoalsArray = userData.activeGoalsArray.sorted(by: {isProgressNeeded($0) && !isProgressNeeded($1)})
            }
                goalOrder = "Goal Type"
        }
        userData.updateOverall()
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack (alignment: .leading) {
                    
                    Text("Overview")
                        .padding(.top, 10)
                        .font(.title2.bold())
                    
                    HStack (spacing: 20) {
                        ZStack (alignment: .leading) {
                            RoundedRectangle(cornerRadius: 25, style: .circular)
                                .frame(width: screenWidth*0.425, height: screenWidth*0.425)
                                .padding(.bottom, 10)
                                .foregroundColor(.gray.opacity(0.25))
                                .foregroundStyle(.ultraThinMaterial)
                            
                            ZStack {
                                CircularProgressView(progress: userData.progressionStart/userData.progressionEnd)
                                    .frame(width: screenWidth*0.15)
                                    .offset(x: screenWidth*0.04, y: -screenWidth*0.12)
                                
                                Text("\(Image(systemName: "flag.fill"))")
                                    .offset(x: screenWidth*0.04, y: -screenWidth*0.12)
                                    .font(.title3.bold())
                            }
                            
                            Text("Progress")
                                .offset(x: screenWidth*0.03, y: 15)
                                .font(.body.bold())
                            
                            if (userData.progressionStart/userData.progressionEnd).isNaN {
                                Text("100%")
                                    .offset(x: screenWidth*0.03, y: 45)
                                    .font(.largeTitle.bold())
                            } else {
                            Text(String(format: "%.f", userData.progressionStart/userData.progressionEnd * 100) + "%")
                                .offset(x: screenWidth*0.03, y: 45)
                                .font(.largeTitle.bold())
                            }
                        }
                        
                        ZStack (alignment: .center) {
                            RoundedRectangle(cornerRadius: 25, style: .circular)
                                .frame(width: screenWidth*0.425, height: screenWidth*0.425, alignment: .leading)
                                .padding(.bottom, 10)
                                .foregroundColor(.gray.opacity(0.25))
                                .foregroundStyle(.ultraThinMaterial)
                            
                            Text(String(userData.activeGoalsArray.count))
                                .offset(x: 0, y: -25)
                                .font(.custom("activeGoalsFont", fixedSize: 90).bold())
                            
                            Text("Active Goals")
                                .offset(x: 0, y: 50)
                                .font(.body.bold())
                            
                            ZStack (alignment: .leading) {
                                Rectangle()
                                    .frame(width: CGFloat(screenWidth*0.35), height: 10, alignment: .center)
                                    .foregroundColor(.gray.opacity(0.75))
                                    .cornerRadius(20)
                                    .offset(x: 0, y: 30)
                                
                                if userData.catagoryScores.isEmpty == false && userData.activeGoalsArray.count != 0 {
                                    CatagoryProgressView(values: userData.catagoryScores)
                                }
                                
                            }
                        }
                    }
                    
                    if localUserData.firstTime {
                        ZStack (alignment: .center) {
                            RoundedRectangle(cornerRadius: 25, style: .circular)
                                .frame(width: screenWidth*0.425*2.125, height: screenWidth*0.425, alignment: .leading)
                                .padding(.bottom, 10)
                                .foregroundColor(.gray.opacity(0.2))
                                .foregroundStyle(.ultraThinMaterial)
                            
                            Text("Click below or click on the plus in the right corner to create a new goal.")
                                .font(.body.bold())
                                .frame(width: screenWidth*0.425*2 - 19)
                                .multilineTextAlignment(.center)
                                .offset(x: 0, y: -35)
                            
                            Button {showingCreateSequence = true}
                                label: {
                            Text("Get Started")
                                .frame(width: screenWidth*0.425*2.125 - 100, height: 40)
                                .background (LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .foregroundColor(.white)
                                .cornerRadius(40)
                                .font(.body.bold())
                                .offset(x: 0, y: 30)
                            }
                        }
                    }
                    if userData.activeGoalsArray.isEmpty == false {
                        
                        withAnimation(.easeIn) {
                            HStack{
                                Text("Active Goals")
                                    .padding(.top, 10)
                                    .font(.title2.bold())
                                
                                Spacer()
                                
                                Menu("\(goalOrder) \(Image(systemName: "chevron.down"))    ") {
                                    Button("Oldest Goals", action: {reOrderGoals(.oldNew)})
                                    Button("Newest Goals", action: {reOrderGoals(.newOld)})
                                    Button("Goal Catagory", action: {reOrderGoals(.catagory)})
                                    Button("Goal Type", action: {reOrderGoals(.type)})
                                }
                                .minimumScaleFactor(0)
                                .offset(x: 5, y: 5)
                            }
                            .frame(width: screenWidth*0.425*2.125)
                            .menuStyle(DefaultMenuStyle())
                        }
                        
                        ForEach(userData.activeGoalsArray) { goal in
                            if goal.state == .active{
                                withAnimation(.spring()) {
                                    NewGoalView(goal: goal)
                                }
                            }
                        }
                    }
                    if userData.completedForToday.isEmpty == false {
                        
                        withAnimation(.easeIn) {
                            Text("Completed Goals Today")
                                .padding(.top, 10)
                                .font(.title2.bold())
                        }
                        
                        ForEach(userData.completedForToday) { goal in
                            if goal.state != .deleted {
                                withAnimation(.easeIn) {
                                    NewGoalView(goal: goal)
                                }
                            }
                        }
                    }
                }
                .sheet(isPresented: $localUserData.showWelcomeScreen) {
                    WelcomeView()
                }
                .sheet(isPresented: $showingCreateSequence) {
                    RootCreateView()
                }
                .sheet(isPresented: $localUserData.showingGoalCompleted) {
                    CompleteView(goal: localUserData.latestCompleteInfo, bottomTextType: localUserData.latestCompleteTextType)
                }
            }
            .navigationTitle("Goals")
            .navigationBarItems(trailing:
                                    Button(action: {
                showingCreateSequence = true
            }) {
                Text("\(Image(systemName: "plus"))")
            }
            )
        }
        .preferredColorScheme(localUserData.darkMode ? .dark : .light)
    }
}

struct GoalsView_Previews: PreviewProvider {
    static let userData = UserData()
    static var previews: some View {
        GoalsView()
            .environmentObject(userData)
    }
}
