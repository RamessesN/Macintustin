//
//  PlaceRow.swift
//  AppContest2025_Macintustin
//
//  Created by 赵禹惟 on 2025/4/18.
//

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
