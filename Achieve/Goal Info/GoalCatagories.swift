//
//  GoalCatagories.swift
//  Achieve
//
//  Created by swift on 2022-07-22.
//

import SwiftUI

enum GoalCatagory : CaseIterable {
    case health
    case education
    case financial
    case personal
    case social
    case lifestyle
    case othercat
    
    var title: String {
        switch self {
            case .health:
                return "Health"
            case .education:
                return "Education"
            case .financial:
                return "Financial"
            case .personal:
                return "Personal"
            case .social:
                return "Social"
            case .lifestyle:
                return "Lifestyle"
            case .othercat:
                return "Other"
        }
    }
    
    var symbol: Image {
        switch self {
            case .health:
                return Image(systemName: "heart.fill")
            case .education:
                return Image(systemName: "lightbulb.fill")
            case .financial:
                return Image(systemName: "dollarsign.circle.fill")
            case .personal:
                return Image(systemName: "person.fill")
            case .social:
                return Image(systemName: "music.mic")
            case .lifestyle:
                return Image(systemName: "paperplane.fill")
            case .othercat:
                return Image(systemName: "flag.fill")
        }
    }
    
    var color: Color {
        switch self {
            case .health:
                return .red
            case .education:
                return .yellow
            case .financial:
                return .green
            case .personal:
                return .purple
            case .social:
                return .orange
            case .lifestyle:
                return .blue
            case .othercat:
                return .gray    
        }
    }
    
}
