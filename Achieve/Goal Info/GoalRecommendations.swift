//
//  GoalRecommendations.swift
//  Achieve
//
//  Created by swift on 2022-07-22.
//

import Foundation

struct preSpecs {
    var selectedAmountSpec: Int = -1
    var selfDirected: Bool = false
}

struct goalWithInfo {
    
    let goal: String
    var limit = 9999
    var canDaily: Bool
    var specs: preSpecs?
    
}

struct recGoals {
    
    let recGoals: [goalWithInfo]
    let goalCatagory: GoalCatagory
    
}

let healthRecs: [goalWithInfo] = [
    goalWithInfo(goal: "Walk X steps", canDaily: true, specs: preSpecs(selectedAmountSpec: 1)),
    goalWithInfo(goal: "Run for X Y", canDaily: true, specs: preSpecs(selectedAmountSpec: 2)),
    goalWithInfo(goal: "Lose X pounds", canDaily: true, specs: preSpecs(selectedAmountSpec: 1)),
    goalWithInfo(goal: "Go to bed before X", limit: 12, canDaily: true, specs: preSpecs(selectedAmountSpec: 1)),
    goalWithInfo(goal: "Eat less junk food", canDaily: true, specs: preSpecs(selfDirected: true)),
    goalWithInfo(goal: "Practice daily meditation", canDaily: false, specs: preSpecs(selfDirected: true)),
    goalWithInfo(goal: "Workout for X Y", canDaily: true, specs: preSpecs(selectedAmountSpec: 2))
]

let educationRecs: [goalWithInfo] = [
    goalWithInfo(goal: "Get a X % in a subject", limit: 100, canDaily: false, specs: preSpecs(selectedAmountSpec: 1)),
    goalWithInfo(goal: "Study for X Y", canDaily: true, specs: preSpecs(selectedAmountSpec: 2)),
    goalWithInfo(goal: "Go to university in following years", canDaily: false, specs: preSpecs(selfDirected: true)),
    goalWithInfo(goal: "Learn the Swift programming language", canDaily: false, specs: preSpecs(selfDirected: true)),
    goalWithInfo(goal: "Practice a skill for X Y", canDaily: true, specs: preSpecs(selectedAmountSpec: 2))
]

let financialRecs: [goalWithInfo] = [
    goalWithInfo(goal: "Save up X dollars for phone", canDaily: false, specs: preSpecs(selectedAmountSpec: 1)),
    goalWithInfo(goal: "Put X dollars into savings", canDaily: true, specs: preSpecs(selectedAmountSpec: 1)),
    goalWithInfo(goal: "Learn more about investments", canDaily: false, specs: preSpecs(selfDirected: true)),
    goalWithInfo(goal: "Pay off debt", canDaily: false, specs: preSpecs(selfDirected: true)),
    goalWithInfo(goal: "Buy a new car", canDaily: true, specs: preSpecs(selfDirected: true))
]

let personalRecs: [goalWithInfo] = [
    goalWithInfo(goal: "Learn to cook", canDaily: false, specs: preSpecs(selfDirected: true)),
    goalWithInfo(goal: "Stress less", canDaily: true, specs: preSpecs(selfDirected: true)),
    goalWithInfo(goal: "Procrastinate less", canDaily: true, specs: preSpecs(selfDirected: true)),
    goalWithInfo(goal: "Be more forgiving", canDaily: true, specs: preSpecs(selfDirected: true)),
    goalWithInfo(goal: "Become better at something", canDaily: false, specs: preSpecs(selfDirected: true))
]

let socialRecs: [goalWithInfo] = [
    goalWithInfo(goal: "Talk to new people", canDaily: true, specs: preSpecs(selfDirected: true)),
    goalWithInfo(goal: "Become more confident", canDaily: false, specs: preSpecs(selfDirected: true)),
    goalWithInfo(goal: "Do something for a friend", canDaily: false, specs: preSpecs(selfDirected: true)),
    goalWithInfo(goal: "Go hang out X times", canDaily: true, specs: preSpecs(selectedAmountSpec: 1)),
    goalWithInfo(goal: "Prepair for upcoming event", canDaily: false, specs: preSpecs(selfDirected: true)),
    goalWithInfo(goal: "Spend more time with family", canDaily: true, specs: preSpecs(selfDirected: true)),
    goalWithInfo(goal: "Talk to friends", canDaily: true, specs: preSpecs(selfDirected: true)),
    goalWithInfo(goal: "Make X new friends", canDaily: true, specs: preSpecs(selectedAmountSpec: 1)),
    goalWithInfo(goal: "Spend time significant other", canDaily: true, specs: preSpecs(selfDirected: true)),
    goalWithInfo(goal: "Get a gift for someone", canDaily: false, specs: preSpecs(selfDirected: true))
]

let lifestyleRecs: [goalWithInfo] = [
    goalWithInfo(goal: "Go on a trip!", canDaily: false, specs: preSpecs(selfDirected: true)),
    goalWithInfo(goal: "Prepair for summer vacation", canDaily: false, specs: preSpecs(selfDirected: true)),
    goalWithInfo(goal: "Learn a new hobby", canDaily: true, specs: preSpecs(selfDirected: true)),
    goalWithInfo(goal: "Practice a hobby X times", canDaily: true, specs: preSpecs(selectedAmountSpec: 1)),
    goalWithInfo(goal: "Live a healthier lifestyle", canDaily: true, specs: preSpecs(selfDirected: true))
]

var catagoryRecsArray: [recGoals] = [
    recGoals(recGoals: healthRecs, goalCatagory: .health),
    recGoals(recGoals: educationRecs, goalCatagory: .education),
    recGoals(recGoals: financialRecs, goalCatagory: .financial),
    recGoals(recGoals: personalRecs, goalCatagory: .personal),
    recGoals(recGoals: socialRecs, goalCatagory: .social),
    recGoals(recGoals: lifestyleRecs, goalCatagory: .lifestyle)
]
