//
//  CompleteView.swift
//  Achieve
//
//  Created by swift on 2022-07-30.
//

import SwiftUI

struct CompleteView: View {

    @EnvironmentObject var screenInfo: goalScreenInfo
    let goal: Goal
    let bottomTextType: Int

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
            
            Text("Goal Complete!")
                .multilineTextAlignment(.center)
                .font(.largeTitle.bold())
            
            smallGoalView(goal: goal)
            
            Button(action: {
                goal.state = .active
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Undo Goal Completion")
                    .frame(width: screenWidth*0.425*2.125 - 100, height: 40)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            
            Button(action: {
                goal.completeGoal(screenInfo, goal)
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
    static var previews: some View {
        CompleteView(goal: Goal(), bottomTextType: 0)
    }
}
