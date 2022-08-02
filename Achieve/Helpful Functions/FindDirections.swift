//
//  FindDirections.swift
//  Achieve
//
//  Created by swift on 2022-07-26.
//

import Foundation

func findDirectionsForUser(_ catagory: GoalCatagory, _ title: String) -> [String] {
    for goaltype in catagoryRecsArray {
        if goaltype.goalCatagory == catagory {
            return createDynamicDirections(goaltype.recGoals, findValuesInTitle(title))
        }
    }
    return ["error"]
}

func createDynamicDirections (_ selectedGoals: [goalWithInfo], _ titleInfo: possibleValues) -> [String] {
    
    var directionList: [String] = []
    
    for goals in selectedGoals {
        directionList.append(goals.goal)
    }
    
    for index in 0...directionList.count-1 {
        if selectedGoals[index].canDaily == true && titleInfo.pSchedule != .none {
            switch titleInfo.pSchedule {
            case .daily:
                directionList[index] += " daily"
            case .weekly:
                directionList[index] += " weekly"
            case .monthly:
                directionList[index] += " monthly"
            case .none:
                directionList[index] += ""
            }
        }
        
        if titleInfo.pTimeframeAmount != 0 && titleInfo.pTimeframeType != .none {
            directionList[index] = directionList[index].replacingOccurrences(of: "X Y", with: "\(titleInfo.pTimeframeAmount) \(titleInfo.pTimeframeType)")
        } else {
            directionList[index] = directionList[index].replacingOccurrences(of: "X Y", with: "30 minutes")
        }
        
        if titleInfo.pReps != 0 {
            if titleInfo.pReps > selectedGoals[index].limit {
                directionList[index] = directionList[index].replacingOccurrences(of: "X", with: "\(selectedGoals[index].limit)")
            } else {
                directionList[index] = directionList[index].replacingOccurrences(of: "X", with: "\(titleInfo.pReps)")
            }
        }else {
            directionList[index] = directionList[index].replacingOccurrences(of: "X", with: "10")
        }
    }
    
    return directionList
    
}
