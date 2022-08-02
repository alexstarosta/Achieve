//
//  File.swift
//  Achieve
//
//  Created by swift on 2022-07-27.
//

import Foundation
import SwiftUI

func addDirectionalValues (_ title:String,_ catagory:GoalCatagory ,_ dIndex:Int) -> GoalSpecs {
    
    let titleInfo = findValuesInTitle(title)
    let newSpecs = GoalSpecs()
    
    if titleInfo.pReps != 0 {
        newSpecs.goalAmount = String(titleInfo.pReps)
    }
    
    if titleInfo.pSchedule != .none {
        switch titleInfo.pSchedule {
        case .daily:
            newSpecs.scheduleType = 1
        case .weekly:
            newSpecs.scheduleType = 2
        case .monthly:
            newSpecs.scheduleType = 3
        case .none:
            newSpecs.scheduleType = -1
        }
        newSpecs.selectedTimeSpec = 1
    }
    
    if titleInfo.pTimeframeType != .none {
        switch titleInfo.pTimeframeType {
        case .minutes:
            newSpecs.amountDurationType = 1
        case .hours:
            newSpecs.amountDurationType = 2
        case .days:
            newSpecs.amountDurationType = 3
        case .none, .weeks, .months:
            newSpecs.amountDurationType = -1
        }
        newSpecs.selectedAmountSpec = 2
    }
    
    if titleInfo.pTimeframeAmount != 0 {
        newSpecs.amountDurationAmount = String(titleInfo.pTimeframeAmount)
    }
    
    for recs in catagoryRecsArray {
        if recs.goalCatagory == catagory {
            newSpecs.selectedAmountSpec = recs.recGoals[dIndex].specs!.selectedAmountSpec
            newSpecs.selfDirected = recs.recGoals[dIndex].specs!.selfDirected
            break
        }
    }
    
    return newSpecs
    
}
