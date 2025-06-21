/**
 @file UserDetailsView.swift
 @project AppContest2025_Macintustin
 
 @brief A SwiftUI view displaying detailed user profile information.
 @details
  This view presents a summary of the current user's profile,
  including:
  - Their name (passed via a binding)
  - Their profile image (if available)
  
  It is typically shown as a secondary screen when the user opts to view or edit profile details.
  This component is fully reactive to updates in bound user data.
 
 @author 赵禹惟
 @date 2025/5/5
 */

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
