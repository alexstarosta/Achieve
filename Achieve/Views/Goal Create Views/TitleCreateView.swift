//
//  TitleCreateView.swift
//  Achieve
//
//  Created by swift on 2022-07-23.
//

import SwiftUI

func randomIcon() -> String{
    let randomInt = Int.random(in: 1..<10)
    
    switch randomInt {
        case 1: return "figure.archery"
        case 2: return "figure.climbing"
        case 3: return "figure.core.training"
        case 4: return "figure.curling"
        case 5: return "figure.hiking"
        case 6: return "figure.run"
        case 7: return "figure.skiing.downhill"
        case 8: return "figure.stairs"
        case 9: return "figure.table.tennis"
        default: return "figure.volleyball"
    }
}

func titleErrorCheck(_ title:String) -> String {
    let characterset = CharacterSet(charactersIn:
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 "
    )
    
    if title == "" {
        return "Please enter a title"
    }
    
    if title.rangeOfCharacter(from: characterset.inverted) != nil {
        return "No special characters allowed in title"
    }
    
    return "NI"
}

struct TitleCreateView: View {
    
    @State var topIcon = randomIcon()
    
    @EnvironmentObject var goal: Goal
    @EnvironmentObject var screenInfo: goalScreenInfo

    @State var displayError = false
    @State var errorText = ""
    @State var sendNextView = false
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack (alignment: .center) {
            VStack {
                ZStack {
                    Circle()
                        .frame(width: 120, height: 120, alignment: .center)
                        .foregroundStyle(achieveStyleSimple)
                        .foregroundStyle(.ultraThinMaterial)
                    Image(topIcon)
                        .scaleEffect(1.5)
                }
                
                Text("Making a Goal")
                    .font(.largeTitle.bold())
                    .padding(.vertical, 30)
            }
            VStack (alignment: .leading) {
                Text("Goal Title")
                    .font(.title2.bold())
                    .padding(.bottom, 2)
                
                Text("Creating a goal is the first step to achieving it. Think about something want to accomplish.")
                    .font(.callout)
                    .padding(.bottom, isTextFieldFocused ? 0 : 10)
                    .fixedSize(horizontal: false, vertical: true)
                
                ZStack{
                    RoundedRectangle(cornerRadius: 100)
                        .frame(width: screenWidth/1.15+6, height: 45, alignment: .center)
                        .foregroundStyle(achieveStyleSimple)
                        .foregroundStyle(.ultraThinMaterial)
                    
                    HStack{
                        
                        Text(Image(systemName: "highlighter"))
                            .foregroundColor(.secondary)
                        
                        TextField("Title of your goal...", text: $goal.title)
                            .onSubmit {
                                let errorCheck = titleErrorCheck(goal.title)
                                if errorCheck != "NI" {
                                    displayError = true
                                    errorText = errorCheck
                                } else {
                                    displayError = false
                                }
                            }
                            .submitLabel(.done)
                            .frame(width: screenWidth/1.4, alignment: .trailing)
                            .focused($isTextFieldFocused)
                            .keyboardType(.alphabet)
                            .disableAutocorrection(true)
                        
                    }
                    .frame(width: screenWidth/1.15 ,height: 40, alignment: .center)
                    .background(Capsule().fill(Color(UIColor.systemBackground)))
                }
                
                Text("\(Image(systemName: "exclamationmark.circle.fill")) \(errorText)")
                    .font(.callout)
                    .foregroundColor(.red)
                    .opacity(displayError ? 1 : 0)
                
            }
            .frame(width: screenWidth*0.85)
            
            Button(action: {
                let errorCheck = titleErrorCheck(goal.title)
                if errorCheck != "NI" {
                    displayError = true
                    errorText = errorCheck
                } else {
                    displayError = false
                    if goal.catagory != nil {
                        goal.extras.directionsForUser = findDirectionsForUser(goal.catagory!, goal.title)
                    }
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
        .background(
            NavigationLink(
                destination: CatagoryCreateView(),
                isActive: $sendNextView,
                label: { EmptyView() })
        )
        .preferredColorScheme(screenInfo.darkMode ? .dark : .light)
    }
}


struct TitleCreateView_Previews: PreviewProvider {
    static let goal = Goal()
    static let screenInfo = goalScreenInfo()
    static var previews: some View {
        NavigationView {
            TitleCreateView()
        }
        .environmentObject(goal)
        .environmentObject(screenInfo)
    }
}
