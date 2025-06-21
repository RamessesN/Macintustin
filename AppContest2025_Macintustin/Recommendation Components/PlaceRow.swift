/**
 @file PlaceRow.swift
 @project AppContest2025_Macintustin
  
 @brief A UI component displaying a single place's name, like count, and comments.
 @details
  PlaceRow is a reusable view used to display an overview of a place's name,
  its current like count, and user comments. It includes:
  - A heart icon with the total like count
  - A place name title
  - A chevron icon that toggles expansion
  - An expandable comment section shown when tapped

  Tapping the row toggles the visibility of the comment section below.

  This view relies on the `LikeManager` environment object for retrieving dynamic like counts.
 
 @author 赵禹惟
 @date 2025/4/18
 */

import SwiftUI

struct PlaceRow: View {
    @EnvironmentObject private var likeManager: LikeManager
    @State private var isExpanded = false
    
    var placeName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ZStack(alignment: .center) {
                    VStack(alignment: .center) {
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.red.opacity(0.8))
                        
                        ZStack(alignment: .center) {
                            Text("\(getLikeCount())")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        }
                        .frame(width: 50, alignment: .center)
                    }
                    .frame(width: 50, alignment: .center)
                }
                .frame(width: 50, alignment: .leading)
                
                Spacer()
                    .frame(width: 10)
                
                Text(placeName)
                    .font(.title3)
                    .bold()
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    .foregroundStyle(.blue)
                    .animation(.easeInOut(duration: 0.1), value: isExpanded)
            }
            .padding(.vertical, 5)
            .frame(maxWidth: .infinity)
            
            if isExpanded {
                CommentSection(placeName: placeName)
                    .frame(maxWidth: .infinity)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isExpanded.toggle()
        }
    }
}

extension PlaceRow {
    func getLikeCount() -> Int {
        return likeManager.likeCounts[placeName] ?? 0
    }
}
