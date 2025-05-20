//
//  UserDetailsView.swift
//  AppContest2025_Macintustin
//
//  Created by 赵禹惟 on 2025/5/5.
//

import SwiftUI

struct UserDetailsView: View {
    @Binding var userName: String
    @Binding var userImage: UIImage?
    
    var body: some View {
        VStack {
            Text("User Details")
                .font(.title)

            if let userImage = userImage {
                Image(uiImage: userImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            } else {
                Text("No image selected.")
            }

            Text("Name: \(userName)")
                .font(.headline)

            Spacer()
        }
        .padding()
    }
}
