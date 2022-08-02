//
//  GoalCreateWelcomeView.swift
//  Achieve
//
//  Created by swift on 2022-07-22.
//

import SwiftUI

struct WelcomeView: View {
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    let screenSize = UIScreen.main.bounds.size
    
    @EnvironmentObject var screenInfo: goalScreenInfo

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
                    VStack {
                        Text("Welcome to")
                            .multilineTextAlignment(.center)
                            .font(.largeTitle.bold())
                            .offset(x: 0, y: 10)
                            .padding(.top, 80)
                        
                            Image("achieveLogo")
                                .scaleEffect(0.9)
                                .padding(.bottom, 50)
                                .offset(y: -10)
                        
                        VStack (spacing: 30) {
                            HStack (alignment: .center) {
                                Text("\(Image(systemName: "highlighter"))")
                                    .font(.custom("", size: 40).bold())
                                    .foregroundColor(.accentColor)
                                    .padding(.trailing, 10)
                               
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
                            
                            HStack (alignment: .center) {
                                Text("\(Image(systemName: "scope"))")
                                    .font(.custom("", size: 36).bold())
                                    .foregroundColor(.accentColor)
                                    .padding(.trailing, 10)
                               
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
                            
                            HStack (alignment: .center) {
                                Text("\(Image(systemName: "hand.thumbsup"))")
                                    .font(.custom("", size: 40).bold())
                                    .foregroundColor(.accentColor)
                                    .padding(.trailing, 10)
                               
                                VStack (alignment: .leading) {
                                    Text("Live Recommendations")
                                        .font(.body)
                                        .bold()
                                    
                                    Text("Find various goal recommendations to help create the best goals.")
                                        .frame(width: screenWidth*0.6, alignment: .leading)
                                        .opacity(0.75)
                                        .font(.body)
                                }
                            }
                            
                        }
                        .frame(height: 300)
                        Button(action: {
                            screenInfo.showWelcomeScreen = false
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
                .preferredColorScheme(screenInfo.darkMode ? .dark : .light)
    }
}

struct GoalCreateWelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
