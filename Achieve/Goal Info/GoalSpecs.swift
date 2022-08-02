//
//  GoalSpecs.swift
//  Achieve
//
//  Created by swift on 2022-07-26.
//

import Foundation

class GoalSpecs {
    @Published var selectedTimeSpec: Int = -1
    @Published var selectedAmountSpec: Int = -1

    @Published var scheduleType: Int = -1
    @Published var durationSpec: Int = -1
    @Published var durationAmount: String = ""

    @Published var finishDate = Date()
    @Published var startingToday: Bool = false

    @Published var goalAmount: String = ""
    @Published var isGoalIncrement: Int = -1
    @Published var goalIncrement: String = ""

    @Published var amountDurationType: Int = -1
    @Published var amountDurationAmount: String = ""

    @Published var selfDirected: Bool = false
}
