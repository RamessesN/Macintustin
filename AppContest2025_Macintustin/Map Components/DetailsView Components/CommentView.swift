/**
 @file CommentView.swift
 @project AppContest2025_Macintustin
 
 @brief A view for writing, editing, and saving comments for a specific location.
 @details
  CommentView provides an interface where users can input or modify textual comments
  associated with a specific placemark. The view uses a TextEditor for comment entry,
  displays a dynamic character counter, and includes "Done" and "Cancel" controls for
  saving or discarding user input.

  On submission, the comment is saved into `UserDefaults` under a key specific to the
  placemark name. Duplicate comments are avoided, and default comments can be loaded
  if none exist yet. The view also handles dismissing itself and restoring any initial
  comment text when it appears.

  It integrates local persistence, dynamic form handling, and navigation controls
  using SwiftUI idioms.
 
 @author 赵禹惟
 @date 2025/4/18
 */

import SwiftUI

struct CommentView: View {
    @State private var commentText: String = ""
    @State private var characterCount: Int = 0
    @Environment(\.dismiss) var dismiss
    
    var placemarkName: String
    var initialComment: String
    
    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $commentText)
                    .padding()
                    .frame(height: 200)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .onChange(of: commentText) {
                        characterCount = commentText.count
                    }
                
                Button(action: {
                    saveComment()
                    dismiss()
                }) {
                    Text("Done")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Comment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .padding()
            .onAppear {
                commentText = initialComment
            }
        }
    }
    
    func saveComment() {
        guard !commentText.isEmpty else { return }
        
        let commentKey = "comments_\(placemarkName)"
        
        var comments: [String] = UserDefaults.standard.stringArray(forKey: commentKey) ?? []
        
        if comments.isEmpty, let sampleComments = AppData.defaultComments[placemarkName], !sampleComments.isEmpty {
            comments = sampleComments
        }
        
        if !comments.contains(commentText) {
            comments.append(commentText)
        }
        
        UserDefaults.standard.set(comments, forKey: commentKey)
    }
}
