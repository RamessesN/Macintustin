//
//  PhotosUpload.swift
//  AppContest2025_Macintustin
//
//  Created by 赵禹惟 on 2025/4/18.
//

import SwiftUI

class PhotoStorage {
    static let shared = PhotoStorage()
    private let fileManager = FileManager.default
    private let documentsDirectory: URL
    
    private init() {
        documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func savePhoto(_ image: UIImage, for location: String, name: String) -> String {
        let locationDirectory = documentsDirectory.appendingPathComponent(location)
        
        if !fileManager.fileExists(atPath: locationDirectory.path) {
            try? fileManager.createDirectory(at: locationDirectory, withIntermediateDirectories: true)
        }
        
        let filename = "\(UUID().uuidString).png"
        let fileURL = locationDirectory.appendingPathComponent(filename)
        
        if let data = image.pngData() {
            try? data.write(to: fileURL)
            return filename
        }
        
        return ""
    }
    
    func loadPhotos(for location: String) -> [UIImage] {
        let locationDirectory = documentsDirectory.appendingPathComponent(location)
        var images: [UIImage] = []
        
        guard let contents = try? fileManager.contentsOfDirectory(atPath: locationDirectory.path) else {
            return images
        }
        
        for filename in contents {
            let fileURL = locationDirectory.appendingPathComponent(filename)
            if let imageData = try? Data(contentsOf: fileURL),
               let image = UIImage(data: imageData) {
                images.append(image)
            }
        }
        
        return images
    }
    
    func deletePhoto(at url: URL) {
        try? fileManager.removeItem(at: url)
    }
}
