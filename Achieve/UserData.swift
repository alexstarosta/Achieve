//
//  UserInfo.swift
//  Achieve
//
//  Created by swift on 2022-08-10.
//

import Foundation

// DATA STORED IN FIREBASE DATABASE
class UserData : ObservableObject {
    
    // ARRAYS OF GOALS
    @Published var activeGoalsArray: [Goal] = []
    @Published var completedForToday: [Goal] = []
    @Published var deletedGoalsArray: [Goal] = []
    @Published var completedGoalsArray: [Goal] = []
    
    // GLOBAL REFRESH SETTING
    @Published var refresh = true
    
    // PROGRESSION BAR
    @Published var progressionEnd: Double = 0
    @Published var progressionStart: Double = 0
    @Published var catagoryScores: [Double] = []
    
    func updateOverall (){
        self.progressionEnd = currentProgressTotal(self.activeGoalsArray)
        self.progressionStart = currentProgressStart(self.activeGoalsArray)
        self.catagoryScores = catagoryPrecedence(self.activeGoalsArray)
        self.refresh.toggle()
    }
    
}

// DATA STORED ON USER DEVICE
class LocalUserData : ObservableObject {
    
    // SHOWS USER FIRST TIME CREATE BUTTON
    @Published var firstTime = true {
        didSet {
            UserDefaults.standard.set(updateLocalSettingsArray(self), forKey: "localData")
        }
    }
    
    // SHOWS USER THE WELCOME SCREEN
    @Published var showWelcomeScreen = true {
        didSet {
            UserDefaults.standard.set(updateLocalSettingsArray(self), forKey: "localData")
        }
    }
    
    // USER SETTINGS BASED ON LOCAL PREFRENCES
    @Published var disableCompletion = false {
        didSet {
            UserDefaults.standard.set(updateLocalSettingsArray(self), forKey: "localData")
        }
    }
    @Published var darkMode = false {
        didSet {
            UserDefaults.standard.set(updateLocalSettingsArray(self), forKey: "localData")
        }
    }
    @Published var notificationAllowed: NotifState = .unknown {
        didSet {
            UserDefaults.standard.set(updateLocalSettingsArray(self), forKey: "localData")
        }
    }
    @Published var notificationBool = false {
        didSet {
            UserDefaults.standard.set(updateLocalSettingsArray(self), forKey: "localData")
        }
    }
    @Published var notificationTime: Date {
        didSet {
            UserDefaults.standard.set(updateLocalSettingsArray(self), forKey: "localData")
        }
    }
    
    // BASIC GOAL COMPLETION INFO
    @Published var showingGoalCompleted = false
    @Published var latestCompleteInfo = Goal()
    @Published var latestCompleteTextType = 0
    
    init() {
        
        let localValues = UserDefaults.standard.object(forKey: "localData") as? [Int]
        
        if localValues == nil {
            var dateComponents = DateComponents()
            dateComponents.hour = 19
            dateComponents.minute = 30

            let userCalendar = Calendar(identifier: .gregorian)
            self.notificationTime = userCalendar.date(from: dateComponents)!
            
        } else {
            
            func intBool(_ int:Int) -> Bool {
                if int == 1 {
                    return true
                } else {
                    return false
                }
            }
            
            func intNotifState (_ int:Int) -> NotifState {
                switch int {
                case 1:
                    return .allowed
                case 0:
                    return .disallowed
                case 2:
                    return .unknown
                default:
                    return .unknown
                }
            }
            
            self.firstTime = intBool(localValues![0])
            self.showWelcomeScreen = intBool(localValues![1])
            self.disableCompletion = intBool(localValues![2])
            self.darkMode = intBool(localValues![3])
            self.notificationBool = intBool(localValues![4])
            
            self.notificationAllowed = intNotifState(localValues![5])
            
            var dateComponents = DateComponents()
            dateComponents.hour = localValues![6]
            dateComponents.minute = localValues![7]

            let userCalendar = Calendar(identifier: .gregorian)
            self.notificationTime = userCalendar.date(from: dateComponents)!
        }
    }
    
    
    
}

func updateLocalSettingsArray(_ localData: LocalUserData) -> [Int] {
    var intArray: [Int] = []
    
    func boolInt(_ bool:Bool) -> Int {
        if bool {
            return 1
        } else {
            return 0
        }
    }
    
    func boolNotifState (_ notifState:NotifState) -> Int {
        switch notifState {
        case .allowed:
            return 1
        case .disallowed:
            return 0
        case .unknown:
            return 2
        }
    }
    
    intArray.append(boolInt(localData.firstTime))
    intArray.append(boolInt(localData.showWelcomeScreen))
    intArray.append(boolInt(localData.disableCompletion))
    intArray.append(boolInt(localData.darkMode))
    intArray.append(boolInt(localData.notificationBool))
    
    intArray.append(boolNotifState(localData.notificationAllowed))
    
    intArray.append(Calendar.current.component(.hour, from: localData.notificationTime))
    intArray.append(Calendar.current.component(.minute, from: localData.notificationTime))
    
    return intArray
    
}
