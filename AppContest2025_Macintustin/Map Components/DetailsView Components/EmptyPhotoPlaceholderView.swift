/**
 @file EmptyPhotoPlaceholderView.swift
 @project AppContest2025_Macintustin
 
 @brief A placeholder view displayed when no photos are available.
 @details
  EmptyPhotoPlaceholderView is a SwiftUI component designed to inform users that no
  photos are currently available for display. It visually encourages interaction by
  showing an icon and instructional text inside a stylized button area.

  When tapped, it sets a bound `@Binding` variable (`showImagePicker`) to `true`,
  triggering an image picker elsewhere in the UI. The layout uses `GeometryReader` to
  proportionally size the placeholder, and includes rounded corners, a border, and
  subtle background styling to maintain design consistency.

  This view is intended for use in photo upload or gallery contexts as a call-to-action
  when no user images have been provided yet.
 
 @author 赵禹惟
 @date 2025/4/18
 */

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
