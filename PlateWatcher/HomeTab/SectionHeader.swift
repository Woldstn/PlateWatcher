//
//  SectionHeader.swift
//  PlateWatcher
//
//  Created by Zachary Pierog on 2020/08/11.
//  Copyright © 2020 Zachary Pierog. All rights reserved.
//

import SwiftUI

struct SectionHeader: View {
    var title: String
    var reset: () -> Void
    
    var body: some View {
        HStack {
            Text(LocalizedStringKey(title))
                .font(.title)
                .fontWeight(.bold)
                .lineLimit(1)
            Spacer()
            Button(action: reset) {
                Text("reset-button")
            }.buttonStyle(ResetButton())
        }
        .padding(.all, 5.0)
        .frame(maxWidth: .infinity)
        .background(Color("HeaderColor"))
    }
}

struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeader(title: "daily-goals", reset: {print("reset")})
    }
}
