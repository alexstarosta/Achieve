//
//  AchievementsView.swift
//  Achieve
//
//  Created by swift on 2022-07-22.
//

import SwiftUI

struct AchievementsView: View {
    
    @EnvironmentObject var screenInfo: goalScreenInfo
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack (alignment: .leading) {
                    
                    Text("Completed Goals")
                        .padding(.top, 10)
                        .font(.title2.bold())
                        .frame(width: screenWidth * 0.92, alignment: .leading)
                    
                    if screenInfo.completedGoalsArray.isEmpty {
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
                        ForEach((0...screenInfo.completedGoalsArray.count-1).reversed(), id: \.self) { index in
                            if screenInfo.completedGoalsArray[index].state != .deleted {
                                smallCompletedGoalView(goal: screenInfo.completedGoalsArray[index])
                            }
                        }
                    }
                    
                    Text("Recently Deleted")
                        .padding(.top, 10)
                        .font(.title2.bold())
                        .frame(width: screenWidth * 0.92, alignment: .leading)
                    
                    if screenInfo.deletedGoalsArray.isEmpty {
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
                        ForEach((0...screenInfo.deletedGoalsArray.count-1).reversed(), id: \.self) { index in
                            if screenInfo.deletedGoalsArray[index].state == .deleted {
                                smallDeletedGoalView(goal: screenInfo.deletedGoalsArray[index])
                            }
                        }
                    }
                    
                }
                .frame(width: screenWidth * 0.90, alignment: .leading)
            }
        .navigationTitle("Achievements")
        }
        .preferredColorScheme(screenInfo.darkMode ? .dark : .light)
    }
}


struct AchievementsView_Previews: PreviewProvider {
    static let screenInfo = goalScreenInfo()
    static var previews: some View {
        AchievementsView()
            .environmentObject(screenInfo)
    }
}
