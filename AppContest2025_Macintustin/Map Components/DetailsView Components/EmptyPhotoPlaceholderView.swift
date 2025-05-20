//
//  EmptyPhotoPlaceholderView.swift
//  AppContest2025_Macintustin
//
//  Created by 赵禹惟 on 2025/4/18.
//

import SwiftUI

struct EmptyPhotoPlaceholderView: View {
    @Binding var showImagePicker: Bool
    
    var body: some View {
        Button(action: {
            showImagePicker = true
        }, label: {
            GeometryReader { geometry in
                VStack(spacing: 8) {
                    Image(systemName: "photo.badge.exclamationmark")
                        .font(.system(size: 40))
                        .foregroundStyle(.gray)
                    
                    Text("No Photos Available")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                    
                    Text("Tap to Upload(Up to 3)")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
                .frame(width: geometry.size.width * 0.65, height: 185)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .frame(maxWidth: .infinity)
            }
        })
        .buttonStyle(PlainButtonStyle())
    }
}
