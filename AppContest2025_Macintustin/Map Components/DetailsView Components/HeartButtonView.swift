/**
 @file HeartButtonView.swift
 @project AppContest2025_Macintustin
 
 @brief A like button view with optional comment prompt and popover support.
 @details
  HeartButtonView is a reusable SwiftUI component that represents a heart-shaped
  "like" button tied to a specific placemark. It displays the current like count and
  manages like/unlike logic using the shared `LikeManager` environment object.

  When the user taps the button to like a placemark:
  - The local like state and count are updated
  - The user is prompted to leave a comment
  - If an existing comment exists, the user can choose to edit it
  - A `CommentView` popover is shown for comment input

  All comment data is saved to `UserDefaults` using a unique key per placemark,
  with support for loading fallback default comments from the `AppData` structure.

  This component encapsulates interactive liking functionality and enhances user
  engagement through optional contextual feedback.
 
 @author 赵禹惟
 @date 2025/4/18
 */

import SwiftUI

struct HeartButtonView: View {
    @EnvironmentObject private var likeManager: LikeManager
    @State private var isLiked: Bool = false
    @State private var showCommentPrompt = false
    @State private var showCommentView = false
    @State private var hasExistingComment = false
    @State private var existingComment: String = ""
    
    var placemarkName: String
    
    var body: some View {
        VStack {
            Button(action: {
                let newIsLiked = !isLiked
                
                if newIsLiked {
                    likeManager.updateLikeCount(for: placemarkName, increment: true)
                    
                    loadExistingComment()
                    showCommentPrompt = true
                } else {
                    likeManager.updateLikeCount(for: placemarkName, increment: false)
                }
                
                likeManager.updateLikeState(for: placemarkName, isLiked: newIsLiked)
                isLiked = newIsLiked
            }, label: {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .resizable()
                    .frame(width: 28, height: 26)
                    .foregroundStyle(.red.opacity(0.8))
            })
            
            Text("\(likeManager.likeCounts[placemarkName] ?? 0)")
                .font(.footnote)
                .foregroundStyle(.gray)
        }
        .padding(.trailing, 18)
        .onAppear {
            isLiked = likeManager.isLikedStates[placemarkName] ?? false
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
    
    func loadExistingComment() {
        let commentKey = "comments_\(placemarkName)"
        
        if let userComments = UserDefaults.standard.stringArray(forKey: commentKey), !userComments.isEmpty {
            existingComment = userComments.last ?? ""
            hasExistingComment = true
            return
        }
        
        if let defaultComments = AppData.defaultComments[placemarkName], !defaultComments.isEmpty {
            existingComment = defaultComments.first ?? ""
            hasExistingComment = false
        } else {
            existingComment = ""
            hasExistingComment = false
        }
    }
}
