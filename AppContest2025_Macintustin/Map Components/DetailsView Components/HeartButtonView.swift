//
//  HeartButtonView.swift
//  AppContest2025_Macintustin
//
//  Created by 赵禹惟 on 2025/4/18.
//

import SwiftUI

struct HeartButtonView: View {
    @State private var isLiked: Bool = UserDefaults.standard.bool(forKey: "isLiked")
    @State private var likeCount: Int = UserDefaults.standard.integer(forKey: "likeCount")
    @State private var showCommentPrompt = false
    @State private var showCommentView = false
    @State private var hasExistingComment = false
    @State private var existingComment: String = ""
    
    var placemarkName: String
    let defaultLikeCounts: [String: Int] = [
        "Ocean University of China (West Coast Campus)": 12,
        "Ocean University of China Xihaian Campus (West Gate)": 12,
        "Ocean University of China West Coast Campus": 12,
        "Haijun Park": 20,
        "Mangrove Tree Town Square": 8
    ]
    
    var body: some View {
        VStack {
            Button(action: {
                if isLiked {
                    likeCount -= 1
                } else {
                    likeCount += 1
                    
                    loadExistingComment()
                    showCommentPrompt = true
                }
                
                isLiked.toggle()
                
                let likeKey = "isLiked_\(placemarkName)"
                let countKey = "likeCount_\(placemarkName)"
                
                UserDefaults.standard.set(isLiked, forKey: likeKey)
                UserDefaults.standard.set(likeCount, forKey: countKey)
            }, label: {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .resizable()
                    .frame(width: 28, height: 26)
                    .foregroundColor(.red.opacity(0.8))
            })
            
            Text("\(likeCount)")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding(.trailing, 18)
        .onAppear {
            loadLikeData()
        }
        .alert(hasExistingComment ? "Edit Your Comment?" : "Write a Comment?", isPresented: $showCommentPrompt) {
            Button("No", role: .cancel) {}
            Button("Yes") {
                showCommentView = true
            }
        } message: {
            Text(hasExistingComment ? "Would you like to edit your existing comment?" : "Please write a comment for this place.")
        }
        .popover(isPresented: $showCommentView) {
            CommentView(
                placemarkName: placemarkName,
                initialComment: hasExistingComment ? existingComment : ""
            )
            .frame(width: 300, height: 400)
            .padding()
            .presentationCompactAdaptation((.popover))
        }
    }
}

extension HeartButtonView {
    func loadLikeData() {
        let likeKey = "isLiked_\(placemarkName)"
        let countKey = "likeCount_\(placemarkName)"
        
        isLiked = UserDefaults.standard.bool(forKey: likeKey)
        likeCount = UserDefaults.standard.integer(forKey: countKey)
                
        if likeCount == 0, let defaultCount = defaultLikeCounts[placemarkName] {
            likeCount = defaultCount
            UserDefaults.standard.set(likeCount, forKey: countKey)
        }
    }
    
    func loadExistingComment() {
        let commentKey = "comments_\(placemarkName)"
        if let comments = UserDefaults.standard.stringArray(forKey: commentKey), !comments.isEmpty {
            existingComment = comments.first ?? ""
            hasExistingComment = true
        } else {
            hasExistingComment = false
            existingComment = ""
        }
    }
}
