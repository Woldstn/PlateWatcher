//
//  PresetImagePicker.swift
//  PlateWatcher
//
//  Created by Zachary Pierog on 2020/08/14.
//  Copyright © 2020 Zachary Pierog. All rights reserved.
//

import SwiftUI

struct PresetImagePickerV2: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var showingImgPicker: Bool
    @Binding var image: String?
    @State var showUserImgPicker = false
    @State var userImage: String?
    var psImages = ["PSI_alcohol", "PSI_carbs", "PSI_fats", "PSI_protein", "PSI_snacks", "PSI_vegetables", "PSI_water"]
    
    init(showingImgPicker: Binding<Bool>, image: Binding<String?>) {
        self._showingImgPicker = showingImgPicker
        self._image = image
        
        let userImages: Array<String>
        let documentdirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageDirectory = documentdirectory.appendingPathComponent("UserImages")
        do {
            userImages = try FileManager.default.contentsOfDirectory(atPath: imageDirectory.path)
        } catch {
            return
        }
        psImages += userImages
    }
    
    var body: some View {
        List {
            ForEach(0..<psImages.count/2 + 1) { i in
                getRow(idx: i*2)
            }
        }.navigationBarTitle("イメージ").sheet(isPresented: $showUserImgPicker, onDismiss: loadImage) {
            ImagePicker(image: self.$userImage)
        }
    }
    
    func addImageButton() -> some View {
        ZStack {
            Rectangle()
                .fill(Color.gray)
                .frame(width: 100, height: 100)
                .cornerRadius(5)
            Text("+")
                .font(.largeTitle)
                .foregroundColor(Color.white)
        }.onTapGesture {
            showUserImgPicker = true
        }
    }
    
    func chooseImage(_ img: String?) {
        if img != nil {
            image = img
        }
        showingImgPicker = false
    }
    
    func loadImage() {
        guard let inputImage = userImage else {return}
        self.image = inputImage
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func getRow(idx: Int) -> some View {
        HStack {
            Spacer()
            if idx >= psImages.count {
                addImageButton()
            } else {
                GoalIcon(psImages[idx]).getImage()?
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100,height: 100)
                    .border(Color.gray, width: 1)
            }
            Spacer()
            if idx >= psImages.count {
                Rectangle().frame(width: 100, height: 100)
            } else if idx + 1 == psImages.count {
                addImageButton()
            } else {
                GoalIcon(psImages[idx+1]).getImage()?
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100,height: 100)
                    .border(Color.gray, width: 1)
            }
            Spacer()
        }
    }
}

struct PresetImagePickerV2_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }
}

struct PreviewWrapperV2: View {
    @State var showingImgPicker: Bool = true
    @State var image: String? = "PSI_protein"
    
    var body: some View {
        PresetImagePickerV2(showingImgPicker: $showingImgPicker, image: $image)
    }
}
