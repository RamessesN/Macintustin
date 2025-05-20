//
//  RecommendationView.swift
//  AppContest2025_Macintustin
//
//  Created by 赵禹惟 on 2025/4/16.
//

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
