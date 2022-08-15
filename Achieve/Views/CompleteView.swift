//
//  CompleteView.swift
//  Achieve
//
//  Created by swift on 2022-07-30.
//

import SwiftUI

struct CompleteView: View {

    @EnvironmentObject var userData: UserData
    @EnvironmentObject var localUserData: LocalUserData
    
    let goal: Goal
    let bottomTextType: Int
    
    @State var iconOpacity = 0
    @State var titleOpacity = 0
    @State var goalOpacity = 0
    
    @State var iconOffset = 50
    @State var titleOffset = 50
    @State var goalOffset = 50

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
            .offset(y: CGFloat(iconOffset))
            .opacity(Double(iconOpacity))
            .onAppear() {
                withAnimation(.spring(dampingFraction: 0.4).delay(0.2), {iconOffset = 0})
                withAnimation(.spring().delay(0.2), {iconOpacity = 1})
            }
            
            Text("Goal Complete!")
                .multilineTextAlignment(.center)
                .font(.largeTitle.bold())
                .offset(y: CGFloat(titleOffset))
                .opacity(Double(titleOpacity))
                .onAppear() {
                    withAnimation(.spring(dampingFraction: 0.4).delay(0.3), {titleOffset = 0})
                    withAnimation(.linear(duration: 0.3).delay(0.3), {titleOpacity = 1})
                }
            
            smallGoalView(goal: goal)
                .offset(y: CGFloat(goalOffset))
                .opacity(Double(goalOpacity))
                .onAppear() {
                    withAnimation(.spring(dampingFraction: 0.4).delay(0.4), {goalOffset = 0})
                    withAnimation(.linear(duration: 0.5).delay(0.4), {goalOpacity = 1})
                }
            
            Button(action: {
                goal.state = .active
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Undo Goal Completion")
                    .frame(width: screenWidth*0.425*2.125 - 100, height: 40)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            
            Button(action: {
                goal.completeGoal(userData, goal)
                self.presentationMode.wrappedValue.dismiss()
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
    static let userData = UserData()
    static let localUserData = LocalUserData()
    static var previews: some View {
        CompleteView(goal: Goal(), bottomTextType: 0)
            .environmentObject(userData)
            .environmentObject(localUserData)
    }
        
}
