/**
 @file UserDataManager.swift
 @project AppContest2025_Macintustin
 
 @brief A singleton utility for managing user profile data.
 @details
  This class provides methods to persist and retrieve user-related data,
  such as:
  - User name (stored using UserDefaults)
  - User profile image (saved to the app's documents directory)

  It abstracts away the data persistence details, allowing views to interact
  with user information in a simple and consistent manner.

  The image is stored as a PNG file in the app’s sandboxed file system.
 
 @author 赵禹惟
 @date 2025/5/6
 */

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
