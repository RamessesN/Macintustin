//
//  PhotoCarouselView.swift
//  AppContest2025_Macintustin
//
//  Created by 赵禹惟 on 2025/4/18.
//

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
