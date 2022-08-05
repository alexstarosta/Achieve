//
//  CatagoryProgressView.swift
//  Achieve
//
//  Created by swift on 2022-07-29.
//

import SwiftUI

struct CatagoryProgressView: View {
    
    let values: [Double]
    let screenWidth = UIScreen.main.bounds.size.width
    
    var body: some View {
        HStack(spacing: 0){
            ForEach(0...6, id: \.self) {index in
                
                Rectangle()
                    .frame(width: CGFloat(screenWidth*0.34)*values[index], height: 8, alignment: .leading)
                    .foregroundColor(GoalCatagory.allCases[index].color)
                    .cornerRadius(20)
                    .offset(x: 0, y: 30)
                    .frame(alignment: .leading)
            }
        }
        .frame(width: CGFloat(screenWidth*0.35), height: 10, alignment: .center)
    }
}
