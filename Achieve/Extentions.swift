//
//  Extentions.swift
//  Achieve
//
//  Created by swift on 2022-08-05.
//

import Foundation
import SwiftUI

// SCREEN EXTENSIONS

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let screenSize = UIScreen.main.bounds.size

// COLOR EXTENSIONS

let achieveStyleSimple = LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing)

let achieveStyleWhite = LinearGradient(gradient: Gradient(colors: [Color(UIColor.systemBackground)]), startPoint: .topLeading, endPoint: .bottomTrailing)

extension Color {
    static let achieveColorLight = Color("AchieveColorLight")
    static let achieveColorHeavy = Color("AchieveColorHeavy")
}
