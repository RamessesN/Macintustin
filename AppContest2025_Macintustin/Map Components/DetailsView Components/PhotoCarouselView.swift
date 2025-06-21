/**
 @file PhotoCarouselView.swift
 @project AppContest2025_Macintustin
 
 @brief A photo carousel view displaying a swipeable gallery of local images.
 @details
  PhotoCarouselView is a SwiftUI component that presents a horizontally
  swipeable photo gallery using a `TabView` with page style. It binds to an
  array of local `UIImage` instances and tracks the currently visible photo
  index.

  If the photo array is empty, it shows an `EmptyPhotoPlaceholderView` that
  prompts users to upload photos.

  The view supports smooth user interaction with photo swiping and integrates
  with an image picker mechanism via the `showImagePicker` binding.

  Designed for use in user profile, gallery, or location detail screens where
  multiple photos can be browsed and managed.
 
 @author 赵禹惟
 @date 2025/4/18
 */

import SwiftUI

struct PhotoCarouselView: View {
    @Binding var currentIndex: Int
    @Binding var localPhotos: [UIImage]
    @Binding var showImagePicker: Bool
    
    var body: some View {
        if !localPhotos.isEmpty {
            TabView(selection: $currentIndex) {
                ForEach(0..<localPhotos.count, id: \.self) { index in
                    Image(uiImage: localPhotos[index])
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8)
                        .clipped()
                        .tag(index)
                }
            }
            .tabViewStyle(.page)
            .frame(height: 220)
        } else {
            EmptyPhotoPlaceholderView(showImagePicker: $showImagePicker)
        }
    }
}
