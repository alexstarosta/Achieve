//
//  CatagoryCreateView.swift
//  Achieve
//
//  Created by swift on 2022-07-24.
//

import SwiftUI

struct CatagoryCreateView: View {
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    let screenSize = UIScreen.main.bounds.size
    
    @EnvironmentObject var goal: Goal
    @EnvironmentObject var screenInfo: goalScreenInfo
    
    @State var catagoryError = false
    @State var sendNextView = false
    
    @State var dropDownOpen = false
    @State var enableDirection = false
    
    func requiredPicker(_ goal: Goal) -> Int {
        if goal.goalInformation.selectedTimeSpec != -1 {
            return 1
        } else if goal.goalInformation.selectedAmountSpec != -1 {
            return 2
        }
        if goal.goalInformation.selfDirected == true {
            return 3
        }
        return 1
    }
    
    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                VStack (alignment: .leading){
                    Text("Goal Catagory")
                        .font(.title2.bold())
                        .padding(.bottom, 2)
                    
                    Text("It's important to know what type of goal you are completing. Select a category that fits your goals needs.")
                        .font(.callout)
                        .padding(.bottom, 10)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 100)
                        .frame(width: screenWidth/1.15+6, height: 45, alignment: .center)
                        .foregroundStyle(achieveStyleSimple)
                        .foregroundStyle(.ultraThinMaterial)
                    
                    RoundedRectangle(cornerRadius: 100)
                        .frame(width: screenWidth/1.15, height: 40, alignment: .center)
                        .foregroundStyle(Color(UIColor.systemBackground))
                        .foregroundStyle(.ultraThinMaterial)
                    
                    HStack {
                        if goal.catagory != nil {
                            Text("\(goal.catagory!.symbol)")
                                .bold()
                        } else {
                            Text("\(Image(systemName: "flag.fill"))")
                                .foregroundColor(.secondary)
                        }
                        
                        if goal.catagory != nil {
                            Text("\(goal.catagory!.title)")
                                .bold()
                        } else {
                            Text("Select a catagory...")
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button {
                            dropDownOpen.toggle()
                            catagoryError = false
                            enableDirection = false
                        } label: {
                            if dropDownOpen == false {
                                Text("\(Image(systemName: "chevron.right"))")
                            } else {
                                Text("\(Image(systemName: "chevron.down"))")
                            }
                        }
                    }
                    .frame(width: screenWidth*0.8, alignment: .center)
                    
                    RoundedRectangle(cornerRadius: 100)
                        .frame(width: screenWidth/1.15, height: 40, alignment: .center)
                        .opacity(0.00001)
                        .foregroundStyle(.ultraThinMaterial)
                        .onTapGesture {
                            withAnimation(.easeOut){ dropDownOpen.toggle()}
                            catagoryError = false
                        }
                    
                }
                
                if catagoryError == true {
                    Text("\(Image(systemName: "exclamationmark.circle.fill")) Please select a catagory")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                ZStack {
                    if dropDownOpen == true {
                        VStack {
                            Spacer()
                            ForEach(0...predictCatagory(goal.title).count-1, id: \.self ) { index in
                                Button {
                                    goal.catagory = predictCatagory(goal.title)[index]
                                    if goal.catagory != nil {
                                        goal.extras.directionsForUser = findDirectionsForUser(goal.catagory!, goal.title)
                                    }
                                }
                            label: {
                                HStack {
                                    Spacer()
                                    Text ("\(predictCatagory(goal.title)[index].symbol)")
                                        .font(.body)
                                    Text ("\(predictCatagory(goal.title)[index].title)")
                                        .bold()
                                    Spacer()
                                }
                            }
                            .buttonStyle(.bordered)
                            .background(goal.catagory == predictCatagory(goal.title)[index] ? Color.accentColor : Color(UIColor.systemBackground))
                            .cornerRadius(30)
                            .foregroundColor(goal.catagory == predictCatagory(goal.title)[index] ? Color(UIColor.systemBackground) : .accentColor)
                                
                            }
                        }
                    }
                    
                    VStack (alignment: .leading) {
                        HStack {
                            Text("Goal Direction")
                                .font(.title2.bold())
                                .padding(.vertical, 2)
                            
                            Text("beta")
                                .font(.caption.bold())
                                .padding(.vertical, 2)
                                .offset(x: -2, y: 5)
                                .foregroundColor(.achieveColorHeavy)
                            
                            Spacer()
                            
                            Toggle ("", isOn: $enableDirection)
                                .labelsHidden()
                                .tint(.accentColor)
                            
                        }
                        .frame(width: screenWidth*0.88)
                        
                        Text("Not sure exactly what goal you have in mind? Below are various reccomendations made just to fit your needs!")
                            .font(.callout)
                            .padding(.bottom, 1)
                            .fixedSize(horizontal: false, vertical: true)
                                            
                        if enableDirection && dropDownOpen == false {
                            ZStack {
                                if goal.catagory != nil && goal.catagory != .othercat {
                                    RoundedRectangle(cornerRadius: 25)
                                        .frame(width: screenWidth/1.15+6, height: 205, alignment: .bottom)
                                        .foregroundStyle(!dropDownOpen ? achieveStyleSimple : LinearGradient(colors: [Color(UIColor.systemBackground)], startPoint: .bottom, endPoint: .bottom))
                                        .foregroundStyle(.ultraThinMaterial)
                                    
                                    RoundedRectangle(cornerRadius: 22)
                                        .frame(width: screenWidth/1.15, height: 200, alignment: .bottom)
                                        .foregroundStyle(Color(UIColor.systemBackground))
                                        .foregroundStyle(.ultraThinMaterial)
                                
                                    Picker("Direction Selection", selection: $goal.directionIndex) {
                                        ForEach(0..<(goal.extras.directionsForUser?.count ?? 0), id: \.self ) { index in
                                            Text("\(goal.extras.directionsForUser![index])")
                                                .bold()
                                                .font(.body)
                                            }
                                        }
                                        .pickerStyle(.wheel)
                                                                        
                                } else if goal.catagory == .othercat {
                                    Text("\(Image(systemName: "exclamationmark.circle.fill")) Select a specific catagory to view goal directions.")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                        .offset(x: 0, y: -10)
                                } else {
                                    Text("\(Image(systemName: "exclamationmark.circle.fill")) Please select a catagory to use Goal Direction.")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                        .offset(x: 0, y: -10)
                                }
                                
                            }
                            .padding(.top)
                        }
                    }
                    .opacity(dropDownOpen ? 0 : 1)
                    .offset(x: 0, y: 40)
                    
                }
            }
            
            Button(action: {
                if goal.catagory == nil {
                    catagoryError = true
                } else {
                    if enableDirection == false {
                        goal.directionIndex = -1
                    }
                    sendNextView = true
                }
                if goal.title != "" && goal.catagory != nil && goal.directionIndex != -1 {
                    goal.goalInformation = addDirectionalValues(goal.title, goal.catagory!, goal.directionIndex)
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
        .frame(width: screenWidth*0.85)
        
        .navigationBarItems(trailing:
                                Button(action: {
            UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
        }) {
            Text("Cancel")
        })
        
        .background(
            NavigationLink(
                destination: SpecificationsCreateView(selectedPicker: requiredPicker(goal)),
                isActive: $sendNextView,
                label: { EmptyView() })
        )
        .preferredColorScheme(screenInfo.darkMode ? .dark : .light)
    }
}

struct CatagoryCreateView_Previews: PreviewProvider {
    static let goal = Goal()
    static let screenInfo = goalScreenInfo()
    static var previews: some View {
        NavigationView {
            CatagoryCreateView()
        }
        .environmentObject(goal)
        .environmentObject(screenInfo)
    }
}
