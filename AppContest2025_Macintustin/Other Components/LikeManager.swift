//
//  LikeManager.swift
//  AppContest2025_Macintustin
//
//  Created by 赵禹惟 on 2025/4/20.
//

import Foundation
import SwiftUI

class LikeManager: ObservableObject {
    @Published var likeCounts: [String: Int] = [:]
    @Published var isLikedStates: [String: Bool] = [:]
    
    init() {
        loadLikeData()
    }
    
    func loadLikeData() {
        for (placeName, defaultCount) in AppData.defaultLikeCounts {
            let countKey = "likeCount_\(placeName)"
            let likedKey = "isLiked_\(placeName)"
            
            let likeCount = UserDefaults.standard.integer(forKey: countKey)
            likeCounts[placeName] = likeCount == 0 ? defaultCount : likeCount
            
            let isLiked = UserDefaults.standard.bool(forKey: likedKey)
            isLikedStates[placeName] = isLiked
        }
    }
    
    func updateLikeState(for placeName: String, isLiked: Bool) {
        let likedKey = "isLiked_\(placeName)"
        
        isLikedStates[placeName] = isLiked
        
        UserDefaults.standard.set(isLiked, forKey: likedKey)
    }
    
    func updateLikeCount(for placeName: String, increment: Bool) {
        let countKey = "likeCount_\(placeName)"
        let currentCount = likeCounts[placeName] ?? AppData.defaultLikeCounts[placeName] ?? 0
        let newCount = increment ? currentCount + 1 : max(currentCount - 1, 0)
        
        likeCounts[placeName] = newCount
        
        UserDefaults.standard.set(newCount, forKey: countKey)
    }
}
