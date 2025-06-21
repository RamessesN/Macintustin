/**
 @file CommentSection.swift
 @project AppContest2025_Macintustin
 
 @brief Displays photos and comments for a specific place.
 @details
  CommentSection is a reusable SwiftUI component that provides:
  - A photo carousel (from both local and user-uploaded photos)
  - A list of default and user-added comments for a given place

  Features:
  - Auto-playing photo slideshow (every 3 seconds if >1 image)
  - Dynamically loads photos and comments based on the provided place name
  - Graceful fallback messages when no comments or photos exist

  It integrates with `AppData.PhotoDatabase`, `AppData.defaultComments`, and user-stored
  data in `UserDefaults` and `PhotoStorage`.

  This view is primarily used within expandable cells (e.g., PlaceRow) to enrich
  user experience with visuals and feedback.
 
 @author 赵禹惟
 @date 2025/4/18
 */

import SwiftUI

struct CommentSection: View {
    @State private var currentIndex: Int = 0
    @State private var localPhotos: [UIImage] = []
    @State private var showImagePicker = false
    @State private var timer: Timer?
    
    var placeName: String
    
    var body: some View {
        VStack {
            PhotoCarouselView(
                currentIndex: $currentIndex,
                localPhotos: $localPhotos,
                showImagePicker: $showImagePicker
            )
            .frame(height: 220)
            
            VStack(alignment: .leading) {
                Text("Comments")
                    .font(.headline)
                    .bold()
                
                if let comments = getComments() {
                    ForEach(Array(comments.enumerated()), id: \.element) { index, comment in
                        HStack(alignment: .top, spacing: 4) {
                            Text("\(index + 1).")
                                .font(.subheadline)
                            
                            Text(comment)
                                .font(.subheadline)
                                .lineLimit(nil)
                        }
                        .padding(.vertical, 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                } else {
                    Text("No comments yet.")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
            )
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            fetchPhotos()
            startTimer()
        }
        .onDisappear {
            stopTimer()
            currentIndex = 0
        }
        .padding(.horizontal)
    }
}

extension CommentSection {
    func getComments() -> [String]? {
        let commentKey = "comments_\(placeName)"
        
        if let userComments = UserDefaults.standard.stringArray(forKey: commentKey), !userComments.isEmpty {
            if let defaultComments = AppData.defaultComments[placeName], !defaultComments.isEmpty {
                var combinedComments = defaultComments
                for comment in userComments {
                    if !combinedComments.contains(comment) {
                        combinedComments.append(comment)
                    }
                }
                return combinedComments
            }
            return userComments
        } else {
            return AppData.defaultComments[placeName]
        }
    }
    
    func fetchPhotos() {
        var fetchedPhotos: [UIImage] = []
            
        if let photoNames = AppData.PhotoDatabase[placeName] {
            for name in photoNames where !name.isEmpty {
                if let image = UIImage(named: name) {
                    fetchedPhotos.append(image)
                }
            }
        }
            
        let userPhotos = PhotoStorage.shared.loadPhotos(for: placeName)
        fetchedPhotos.append(contentsOf: userPhotos)
            
        localPhotos = fetchedPhotos
        currentIndex = 0
    }
    
    func startTimer() {
        guard localPhotos.count > 1 else {
            stopTimer()
            return
        }
        
        stopTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 0.5)) {
                    currentIndex = (currentIndex + 1) % localPhotos.count
                }
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
