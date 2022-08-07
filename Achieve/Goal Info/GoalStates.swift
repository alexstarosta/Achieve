//
//  GoalStates.swift
//  Achieve
//
//  Created by swift on 2022-08-05.
//

import Foundation

enum GoalState {
    case custom
    case active
    case completed
    case doneToday
    case deleted
    case gone
}

enum GoalOrder {
    case oldNew
    case newOld
    case catagory
    case type
}
