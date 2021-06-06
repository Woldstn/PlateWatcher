//
//  ImagePicker.swift
//  PlateWatcher
//
//  Created by Zachary Pierog on 2020/08/13.
//  Copyright © 2020 Zachary Pierog. All rights reserved.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: String?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let imgURL = info[.imageURL] as? String {
                parent.image = imgURL
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
    
    func saveImageToFolder(info: [UIImagePickerController.InfoKey: Any]) -> String {
        //
        let uiImage = info[.originalImage] as? UIImage
        let imageData = uiImage?.jpegData(compressionQuality: 1.0)
        let imageURL = info[.imageURL] as? String
        let imageName = imageURL?.split(separator: "/").last
        let imageNameNoExt = imageName?.split(separator: ".").first
        let userImageDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("UserImages")
        guard let imageFile = userImageDirectory?.appendingPathComponent("ui_\(String(describing: imageNameNoExt)).jpg") else { return "" }
        do {
            try imageData?.write(to: imageFile)
            return "ui_\(String(describing: imageNameNoExt)).jpg"
        } catch {
            return ""
        }
    }
}
