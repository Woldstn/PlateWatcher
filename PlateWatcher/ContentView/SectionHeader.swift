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
            Text(title).font(.title).fontWeight(.bold)
            Spacer()
            Button(action: reset) {
                Text("リセット")
            }.buttonStyle(ResetButton())
        }
        .padding(.all, 5.0)
        .frame(maxWidth: .infinity)
        .background(Color("HeaderColor"))
    }
}

struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeader(title: "日間ゴール", reset: {print("reset")})
    }
}
