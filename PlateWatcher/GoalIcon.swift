//
//  GoalIcon.swift
//  PlateWatcher
//
//  Created by Zachary Pierog on 2021/05/23.
//  Copyright © 2021 Zachary Pierog. All rights reserved.
//

import SwiftUI

struct GoalIcon: View {
    let imageId: String
    let userImageDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("UserImages")
    
    init(_ imageId: String) {
        self.imageId = imageId
    }
    
    var body: some View {
        getImage()
    }
    
    func getUserImageFile() -> URL? {
        let imageURL = userImageDirectory!.appendingPathComponent(imageId)
        if FileManager.default.fileExists(atPath: imageURL.path) {
            return imageURL
        }
        return nil
    }
    
    func getImage() -> Image? {
        if imageId.hasPrefix("PSI_") {
            if UIImage(named: imageId) != nil {
                return Image(imageId)
            }
            return nil
        }
        if imageId.hasPrefix("ui_") {
            guard let uiImage = UIImage(contentsOfFile: getUserImageFile()!.path) else { return nil }
            return Image(uiImage: uiImage)
        }
        return nil
    }
    
    func resizable() -> Image {
        return (getImage() ?? Image("")).resizable()
    }
}

struct GoalIcon_Previews: PreviewProvider {
    static var previews: some View {
        GoalIcon("PSI_water")
    }
}
