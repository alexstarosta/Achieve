//
//  AchievementsView.swift
//  Achieve
//
//  Created by swift on 2022-07-22.
//

import SwiftUI

struct AchievementsView: View {
    
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var localUserData: LocalUserData
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack (alignment: .leading) {
                    
                    Text("Completed Goals")
                        .padding(.top, 10)
                        .font(.title2.bold())
                        .frame(width: screenWidth * 0.92, alignment: .leading)
                    
                    if userData.completedGoalsArray.isEmpty {
                        ZStack (alignment: .center) {
                            RoundedRectangle(cornerRadius: 25, style: .circular)
                                .frame(width: screenWidth*0.425*2.125, height: screenWidth*0.425, alignment: .leading)
                                .padding(.bottom, 10)
                                .foregroundColor(.gray.opacity(0.2))
                                .foregroundStyle(.ultraThinMaterial)
                            
                            ZStack {
                                
                                Circle()
                                    .frame(width: 70, height: 80, alignment: .center)
                                    .foregroundStyle(achieveStyleSimple)
                                
                                Image(systemName: "questionmark.folder.fill")
                                    .scaleEffect(2)
                                    .foregroundColor(.white)
                                
                            }
                            .offset(y: -30)
                            
                            Text("Hmm... It seems you have not completed any goals. Keep at it!")
                                .font(.body.bold())
                                .frame(width: screenWidth*0.425*2 - 19)
                                .multilineTextAlignment(.center)
                                .offset(x: 0, y: 35)
                        }
                    } else {
                        ForEach((0...userData.completedGoalsArray.count-1).reversed(), id: \.self) { index in
                            if userData.completedGoalsArray[index].state != .deleted {
                                smallCompletedGoalView(goal: userData.completedGoalsArray[index])
                            }
                        }
                    }
                    
                    Text("Recently Deleted")
                        .padding(.top, 10)
                        .font(.title2.bold())
                        .frame(width: screenWidth * 0.92, alignment: .leading)
                    
                    if userData.deletedGoalsArray.isEmpty {
                    ZStack (alignment: .center) {
                        RoundedRectangle(cornerRadius: 25, style: .circular)
                            .frame(width: screenWidth*0.425*2.125, height: screenWidth*0.425, alignment: .leading)
                            .padding(.bottom, 10)
                            .foregroundColor(.gray.opacity(0.2))
                            .foregroundStyle(.ultraThinMaterial)
                        
                        ZStack {
                            
                            Circle()
                                .frame(width: 70, height: 80, alignment: .center)
                                .foregroundStyle(achieveStyleSimple)
                            
                            Image(systemName: "paperplane.fill")
                                .scaleEffect(2)
                                .foregroundColor(.white)
                            
                        }
                        .offset(y: -30)
                        
                        Text("No deleted goals. Keep it up!")
                            .font(.body.bold())
                            .frame(width: screenWidth*0.425*2 - 19)
                            .multilineTextAlignment(.center)
                            .offset(x: 0, y: 35)
                        }
                    } else {
                        ForEach((0...userData.deletedGoalsArray.count-1).reversed(), id: \.self) { index in
                            if userData.deletedGoalsArray[index].state == .deleted {
                                smallDeletedGoalView(goal: userData.deletedGoalsArray[index])
                            }
                        }
                    }
                    
                }
                .frame(width: screenWidth * 0.90, alignment: .leading)
            }
        .navigationTitle("Achievements")
        }
        .preferredColorScheme(localUserData.darkMode ? .dark : .light)
    }
}


struct AchievementsView_Previews: PreviewProvider {
    static let userData = UserData()
    static var previews: some View {
        AchievementsView()
            .environmentObject(userData)
    }
}
