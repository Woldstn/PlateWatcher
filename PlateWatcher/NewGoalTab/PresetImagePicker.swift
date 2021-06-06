//
//  PresetImagePicker.swift
//  PlateWatcher
//
//  Created by Zachary Pierog on 2020/08/14.
//  Copyright © 2020 Zachary Pierog. All rights reserved.
//

import SwiftUI

struct PresetImagePicker: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var showingImgPicker: Bool
    @Binding var image: String?
    var psImages = ["PSI_alcohol", "PSI_carbs", "PSI_fats", "PSI_protein", "PSI_snacks", "PSI_vegetables", "PSI_water"]
    
    var body: some View {
        List {
            ForEach(0..<rowQty()) { i in
                getRow(idx: i*2)
            }
        }
        .navigationBarTitle("イメージ")
    }
    
    func chooseImage(_ img: String?) {
        if img != nil {
            image = img
        }
        showingImgPicker = false
    }
    
    func getRow(idx: Int) -> some View {
        HStack {
            Spacer()
            if idx >= psImages.count {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 100, height: 100)
            } else {
                Image(psImages[idx])
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100,height: 100)
                    .border(Color.gray, width: 1)
                    .onTapGesture {
                        chooseImage(psImages[idx])
                    }
            }
            Spacer()
            if idx + 1 >= psImages.count {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 100, height: 100)
            } else {
                Image(psImages[idx+1])
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100,height: 100)
                    .border(Color.gray, width: 1)
                    .onTapGesture {
                        chooseImage(psImages[idx+1])
                    }
            }
            Spacer()
        }
    }
    
    func rowQty() -> Int {
        return psImages.count/2 + psImages.count%2
    }
}

struct PresetImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }
}

struct PreviewWrapper: View {
    @State var showingImgPicker: Bool = true
    @State var image: String? = "PSI_protein"
    
    var body: some View {
        PresetImagePicker(showingImgPicker: $showingImgPicker, image: $image)
    }
}
