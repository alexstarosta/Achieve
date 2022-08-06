//
//  RootCreateView.swift
//  Achieve
//
//  Created by swift on 2022-07-24.
//

import SwiftUI

struct RootCreateView: View {
    
    @StateObject var goal = Goal()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                TitleCreateView()
            }
                .navigationBarItems(trailing:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                })
        }
        .environmentObject(goal)
        
    }
}

struct RootCreateView_Previews: PreviewProvider {
    static var previews: some View {
        RootCreateView()
    }
}
