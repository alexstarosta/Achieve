//
//  SettingsView.swift
//  Achieve
//
//  Created by swift on 2022-07-22.
//

import SwiftUI
import UserNotifications

enum NotifState {
    case allowed
    case disallowed
    case unknown
}

func randomSubtitle() -> String {
    let randomInt = Int.random(in: 1..<7)
    
    switch randomInt {
        case 1: return "Remember to check your goals!"
        case 2: return "Just a quick reminder to check your goals!"
        case 3: return "Check your goals for today, you got this!"
        case 4: return "Remember to check your goals for today!"
        case 5: return "Had a productive day today? Be sure to check your goals!"
        case 6: return "Made some progress? Be sure to update your goals!"
        default: return "Remember to update your goals for today!"
    }
    
}

struct SettingsView: View {
    
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var localUserData: LocalUserData
    
    @Environment(\.scenePhase) var scenePhase
    
    init(){
        UITableView.appearance().backgroundColor = UIColor.systemGroupedBackground
    }
    
    func checkNotifPerms() {
        let currentPermission = UNUserNotificationCenter.current()
        
        currentPermission.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .denied, .provisional, .ephemeral:
                DispatchQueue.main.async {
                    localUserData.notificationAllowed = .disallowed
                }
            case .authorized:
                DispatchQueue.main.async {
                    localUserData.notificationAllowed = .allowed
                }
            case .notDetermined:
                DispatchQueue.main.async {
                    localUserData.notificationAllowed = .unknown
                }
            @unknown default:
                localUserData.notificationAllowed = .disallowed
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack{
                Form{
                    Section(header: Text("DISPLAY"), footer: Text("The goal completion screen after completing a goal will not appear.")){
                        Toggle("Disable completion screen", isOn: $localUserData.disableCompletion)
                            .tint(.accentColor)
                    }
                    
                    Section("COLORS"){
                        Toggle("Dark mode", isOn: $localUserData.darkMode)
                            .tint(.accentColor)
                    }
                    
                    Section(header: Text("NOTIFICATIONS"), footer: Text("Achieve with send a notification at a specific time to remind you to update your goals.")){
                        
                        if localUserData.notificationAllowed == .allowed {
                            Toggle("Activate notifications", isOn: $localUserData.notificationBool)
                                .tint(.accentColor)
                            
                        } else if localUserData.notificationAllowed == .disallowed {
                            Text("Allow \"Achieve\" to send notifications in settings")
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
                            
                        } else {
                            Button("Allow Notifications") {
                                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                    if success {
                                        checkNotifPerms()
                                    }
                                }
                            }
                        }
                        
                        
                        if localUserData.notificationBool == true {
                            HStack{
                                Text("Notification time")
                                Spacer()
                                DatePicker("", selection: $localUserData.notificationTime, displayedComponents: .hourAndMinute)
                                    
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
        .preferredColorScheme(localUserData.darkMode ? .dark : .light)
        .onAppear() {
            checkNotifPerms()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                checkNotifPerms()
            }
        }
        .onChange(of: localUserData.notificationBool) { bool in
            if bool == false {
                UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["reminderNotif"])
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["reminderNotif"])
            } else {
                let content = UNMutableNotificationContent()
                content.title = "Achieve Goal Reminder"
                content.body = randomSubtitle()
                content.sound = UNNotificationSound.default
                
                var notifDate = DateComponents()
                let calendar = Calendar.current
                notifDate.hour = calendar.component(.hour, from: localUserData.notificationTime)
                notifDate.minute = calendar.component(.minute, from: localUserData.notificationTime)
                let trigger = UNCalendarNotificationTrigger(dateMatching: notifDate, repeats: true)
                
                let request = UNNotificationRequest(
                    identifier: "reminderNotif", content: content, trigger: trigger
                )
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
        .onChange(of: localUserData.notificationTime) { time in
            
            if localUserData.notificationBool == false {return}
            
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["reminderNotif"])
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["reminderNotif"])
            
            let content = UNMutableNotificationContent()
            content.title = "Achieve Goal Reminder"
            content.body = randomSubtitle()
            content.sound = UNNotificationSound.default
            
            var notifDate = DateComponents()
            let calendar = Calendar.current
            notifDate.hour = calendar.component(.hour, from: time)
            notifDate.minute = calendar.component(.minute, from: time)
            let trigger = UNCalendarNotificationTrigger(dateMatching: notifDate, repeats: true)
            
            let request = UNNotificationRequest(
                identifier: "reminderNotif", content: content, trigger: trigger
            )
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static let userData = UserData()
    static let localUserData = LocalUserData()
    static var previews: some View {
        SettingsView()
            .environmentObject(userData)
            .environmentObject(localUserData)
    }
}
