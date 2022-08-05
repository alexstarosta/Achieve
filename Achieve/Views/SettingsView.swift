//
//  SettingsView.swift
//  Achieve
//
//  Created by swift on 2022-07-22.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var screenInfo: goalScreenInfo
    
    init(){
        UITableView.appearance().backgroundColor = UIColor.systemGroupedBackground
    }
    
    var body: some View {
        NavigationView {
            VStack{
                Form{
                    Section(header: Text("DISPLAY"), footer: Text("The goal completion screen after completing a goal will not appear.")){
                        Toggle("Disable completion screen", isOn: $screenInfo.disableCompletion)
                            .tint(.accentColor)
                    }
                    
                    Section("COLORS"){
                        Toggle("Dark mode", isOn: $screenInfo.darkMode)
                            .tint(.accentColor)
                    }
                    
                    Section(header: Text("NOTIFICATIONS"), footer: Text("Achieve with send a notification at a specific time to remind you to update your goals.")){
                        Toggle("Activate notifications", isOn: $screenInfo.notificationBool)
                            .tint(.accentColor)
                        if screenInfo.notificationBool == true {
                            HStack{
                                Text("Notification time")
                                Spacer()
                                DatePicker("", selection: $screenInfo.notificationTime, displayedComponents: .hourAndMinute)
                            }
                        }
                    }
                    
                    Section(header: Text("ABOUT"), footer: Text("Created by Alex Starosta during the OWH x Apple Summer Co-op.")){
                        HStack{
                            Text("Version")
                            Spacer()
                            if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                            Text("\(appVersion)")
                                    .foregroundColor(.secondary)
                            }
                        }
                        HStack{
                            Text("Build")
                            Spacer()
                            if let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                                Text("\(buildVersion)")
                                        .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                }
            }
            .navigationTitle("Settings")
        }
        .preferredColorScheme(screenInfo.darkMode ? .dark : .light)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static let screenInfo = goalScreenInfo()
    static var previews: some View {
        SettingsView()
            .environmentObject(screenInfo)
    }
}
