//
//  CommentView.swift
//  AppContest2025_Macintustin
//
//  Created by 赵禹惟 on 2025/4/18.
//

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
