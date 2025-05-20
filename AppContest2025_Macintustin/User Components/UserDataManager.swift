//
//  UserDataManager.swift
//  AppContest2025_Macintustin
//
//  Created by 赵禹惟 on 2025/5/6.
//

import Foundation
import SwiftUI

class UserDataManager {
    static let shared = UserDataManager()
    
    private let userDefaults = UserDefaults.standard
    private let imageNameKey = "userImageName"
    private let userNameKey = "userName"
    
    func saveUserName(_ name: String) {
        userDefaults.set(name, forKey: userNameKey)
    }
    
    func saveUserImage(_ image: UIImage) -> String? {
        let fileName = "user_image.png"
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            try image.pngData()?.write(to: fileURL)
            userDefaults.set(fileName, forKey: imageNameKey)
            return fileName
        } catch {
            print("Error saving image: $error)")
            return nil
        }
    }
    
    func loadUserName() -> String {
        return userDefaults.string(forKey: userNameKey) ?? "User name"
    }
    
    func loadUserImage() -> UIImage? {
        guard let fileName = userDefaults.string(forKey: imageNameKey) else { return nil }
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            let data = try Data(contentsOf: fileURL)
            return UIImage(data: data)
        } catch {
            print("Error loading image: $error)")
            return nil
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
