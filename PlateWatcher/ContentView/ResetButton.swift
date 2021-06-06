//
//  ResetButton.swift
//  PlateWatcher
//
//  Created by Zachary Pierog on 2020/08/11.
//  Copyright © 2020 Zachary Pierog. All rights reserved.
//

import Foundation
import SwiftUI

let aColor = Color(red: 0, green: 0, blue: 0.5)
let bColor = Color(red: 0, green: 0, blue: 0.9)

struct ResetButton: ButtonStyle {
    let bGradient = Gradient(colors: [aColor, bColor])
    let pGradient = Gradient(colors: [bColor, aColor])
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.all, 10)
            .foregroundColor(Color.white)
            .background(LinearGradient(gradient: configuration.isPressed ? pGradient : bGradient, startPoint: .top, endPoint: .bottom))
            .cornerRadius(20)
    }
}

struct ResetButton_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
        Text("リセット")
        }
        .buttonStyle(ResetButton())
    }
}
