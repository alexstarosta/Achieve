//
//  GoalStructure.swift
//  Achieve
//
//  Created by swift on 2022-08-05.
//

import Foundation
import SwiftUI

class Goal: ObservableObject {
    
    @Published var title: String
    @Published var displayTitle: String
    
    @Published var catagory: GoalCatagory?
    
    @Published var directionIndex: Int
    
    @Published var goalInformation = GoalInformation()
    
    @Published var accentColor: Color
    @Published var backgroundColor: Color
    
    @Published var state: GoalState
    
    @Published var timesCompleted: Int
    
    @Published var extras = GoalExtras()
    
    @Published var goalID = UUID()
    
    init() {
        self.title = ""
        self.displayTitle = ""
        self.directionIndex = -1
        self.accentColor = Color.black
        self.backgroundColor = Color.gray
        self.state = .custom
        self.timesCompleted = 0
    }
    
}

class GoalExtras {
    
    @Published var directionsForUser: [String]? = []
    @Published var startingNum: Int = 0
    
}
