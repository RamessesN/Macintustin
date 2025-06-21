/**
 @file RecommendationView.swift
 @project AppContest2025_Macintustin
 
 @brief A view displaying the top 10 most liked places.
 @details
  RecommendationView presents a ranked list of places based on their like counts,
  retrieved from the shared LikeManager environment object. This component serves as a simple recommendation system based on user preferences.
 
 @author 赵禹惟
 @date 2025/4/16
 */

import SwiftUI

struct RecommendationView: View {
    @EnvironmentObject private var likeManager: LikeManager
    
    var body: some View {
        NavigationView {
            List {
                ForEach(getTop10Places(), id: \.name) { place in
                    PlaceRow(placeName: place.name)
                }
            }
            .navigationTitle("Top 10")
            .onAppear {
                likeManager.loadLikeData()
            }
        }
    }
    
    func getTop10Places() -> [(name: String, likeCount: Int)] {
        return likeManager.likeCounts
            .sorted { $0.value > $1.value }
            .prefix(10)
            .map { (name: $0.key, likeCount: $0.value) }
    }
}
