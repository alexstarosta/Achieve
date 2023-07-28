//
//  GoalCreateWelcomeView.swift
//  Achieve
//
//  Created by swift on 2022-07-22.
//

import SwiftUI

struct WelcomeView: View {
    
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var localUserData: LocalUserData
    
    @State var titleOffset = -screenWidth
    @State var titleLogoOffset = -screenWidth
    
    @State var tip1Offset = screenWidth
    @State var tip2Offset = screenWidth
    @State var tip3Offset = screenWidth
    
    @State var icon1Rotation = 0
    @State var icon2Rotation = 0
    @State var icon3Rotation = 0
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
                    VStack {
                        Text("Welcome to")
                            .multilineTextAlignment(.center)
                            .font(.largeTitle.bold())
                            .offset(x: CGFloat(titleOffset), y: 10)
                            .padding(.top, 80)
                            .onAppear {
                                withAnimation(.spring().delay(0.75), {titleOffset = 0})
                            }
                        
                            Image("achieveLogo")
                                .scaleEffect(0.9)
                                .padding(.bottom, 50)
                                .offset(x: CGFloat(titleLogoOffset), y: -10)
                                .onAppear {
                                    withAnimation(.spring().delay(0.85), {titleLogoOffset = 0})
                                }
                        
                        VStack (spacing: 30) {
                            HStack (alignment: .center) {
                                Text("\(Image(systemName: "highlighter"))")
                                    .font(.custom("", size: 40).bold())
                                    .foregroundColor(.accentColor)
                                    .padding(.trailing, 10)
                                    .rotationEffect(.degrees(Double(icon1Rotation)))
                                    .onAppear {
                                        withAnimation(.spring().delay(1.35), {icon1Rotation = 360})
                                    }
                               
                                VStack (alignment: .leading) {
                                    Text("Customization")
                                        .font(.body)
                                        .bold()
                                    
                                    Text("Edit and specify your goal to personally fit your needs.")
                                        .frame(width: screenWidth*0.6, alignment: .leading)
                                        .opacity(0.75)
                                        .font(.body)
                                }
                            }
                            .padding(.bottom, 5)
                            .offset(x: tip1Offset, y: 0)
                            .onAppear {
                                withAnimation(.spring().delay(1.25), {tip1Offset = 0})
                            }
                            
                            HStack (alignment: .center) {
                                Text("\(Image(systemName: "scope"))")
                                    .font(.custom("", size: 36).bold())
                                    .foregroundColor(.accentColor)
                                    .padding(.trailing, 10)
                                    .rotationEffect(.degrees(Double(icon2Rotation)))
                                    .onAppear {
                                        withAnimation(.spring().delay(1.45), {icon2Rotation = 360})
                                    }
                               
                                VStack (alignment: .leading) {
                                    Text("Goal Tracking")
                                        .font(.body)
                                        .bold()
                                    
                                    Text("Create ways to accurately and automatically track your goals.")
                                        .frame(width: screenWidth*0.6, alignment: .leading)
                                        .opacity(0.75)
                                        .font(.body)
                                }
                            }
                            .padding(.bottom, 2)
                            .offset(x: tip2Offset, y: 0)
                            .onAppear {
                                withAnimation(.spring().delay(1.35), {tip2Offset = 0})
                            }
                            
                            HStack (alignment: .center) {
                                Text("\(Image(systemName: "hand.thumbsup"))")
                                    .font(.custom("", size: 40).bold())
                                    .foregroundColor(.accentColor)
                                    .padding(.trailing, 10)
                                    .rotationEffect(.degrees(Double(icon3Rotation)))
                                    .onAppear {
                                        withAnimation(.spring().delay(1.55), {icon3Rotation = 360})
                                    }
                               
                                VStack (alignment: .leading) {
                                    Text("Live Recommendations")
                                        .font(.body)
                                        .bold()
                                    
                                    Text("Find various goal recommendations to help create the best goals.")
                                        .frame(width: screenWidth*0.62, alignment: .leading)
                                        .opacity(0.75)
                                        .font(.body)
                                }
                            }
                            .offset(x: tip3Offset, y: 0)
                            .onAppear {
                                withAnimation(.spring().delay(1.45), {tip3Offset = 0})
                            }
                            
                        }
                        .frame(height: 300)
                        Button(action: {
                            localUserData.showWelcomeScreen = false
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Continue")
                                .frame(width: screenWidth*0.425*2.125 - 100, height: 40)
                                .background (LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .foregroundColor(.white)
                                .cornerRadius(40)
                                .font(.body.bold())
                                .padding(.bottom)
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                }
                .offset(x: 0, y: -10)
                .preferredColorScheme(localUserData.darkMode ? .dark : .light)
    }
}

struct GoalCreateWelcomeView_Previews: PreviewProvider {
    static let goal = Goal()
    static let userData = UserData()
    static var previews: some View {
        ZStack {
            WelcomeView()
        }
        .environmentObject(goal)
        .environmentObject(userData)
    }
}
