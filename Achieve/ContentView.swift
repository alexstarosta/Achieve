//
//  ContentView.swift
//  Achieve
//
//  Created by swift on 2022-07-22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var userData = UserData()
    @StateObject var localUserData = LocalUserData()
    var body: some View {
        TabView {
            GoalsView()
                .tabItem{
                    Image(systemName: "flag")
                    Text("Goals")
                }
            
            AchievementsView()
                .tabItem{
                    Image("achieveIconBlankBlack")
                    Text("Achievements")
                }
            
            SettingsView()
                .tabItem{
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
        .environmentObject(userData)
        .environmentObject(localUserData)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
