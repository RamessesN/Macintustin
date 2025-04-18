//
//  CommentView.swift
//  AppContest2025_Macintustin
//
//  Created by 赵禹惟 on 2025/4/18.
//

import SwiftUI

struct CommentView: View {
    @Environment(\.dismiss) var dismiss
    @State private var commentText: String = ""
    
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
                
                Button(action: {
                    saveComment()
                    dismiss()
                }) {
                    Text("Done")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
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
        
        if let index = comments.firstIndex(where: { $0 == initialComment }) {
            comments[index] = commentText
        } else {
            comments.append(commentText)
        }
        
        UserDefaults.standard.set(comments, forKey: commentKey)
    }
}
