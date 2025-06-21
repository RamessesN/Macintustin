/**
 @file UserView.swift
 @project AppContest2025_Macintustin
 
 @brief A user profile view allowing name editing and profile picture selection.
 @details
  UserView is a SwiftUI-based profile management interface where users can:
  - View and update their username
  - View and select a profile image from their photo library
  - Navigate to a detailed settings page

  The view loads initial data from a shared UserDataManager singleton and saves
  any changes (e.g., to name or image) back to persistent storage. Image selection
  is handled through a custom `ImagePicker` component. The UI includes a circular
  profile image view, a text field for the username, and a button leading to
  advanced user settings via a `NavigationDestination`.

  This view demonstrates integration of state management, user interaction,
  and local data persistence in a user-centric interface.
 
 @author 赵禹惟
 @date 2025/4/16
 */

import SwiftUI

struct UserView: View {
    @State private var isShowingDetail = false
    @State private var userName: String
    @State private var userImage: UIImage?
    @State private var showingImagePicker = false
    @State private var selectedImages: [UIImage] = []
    
    init() {
        _userName = State(initialValue: UserDataManager.shared.loadUserName())
        _userImage = State(initialValue: UserDataManager.shared.loadUserImage())
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .center, spacing: 8) {
                        if let userImage = userImage {
                            Image(uiImage: userImage)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                                .onTapGesture {
                                    showingImagePicker = true
                                }
                        } else {
                            Image(systemName:"person.crop.circle.badge.exclamationmark")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(.blue)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                                .onTapGesture {
                                    showingImagePicker = true
                                }
                        }
                        
                        TextField("Enter Your Name", text: $userName)
                            .font(.title2)
                            .frame(height: 30)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 12)
                    }
                    Spacer()
                }
                .padding(.top, 40)
                .padding(.leading)
                    
                Button(action: {
                    isShowingDetail = true
                }) {
                    Image(systemName: "slider.horizontal.2.square")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(.blue)
                }
                .padding()
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(
                    selectedImages: $selectedImages,
                    didFinishPicking: { images in
                        if let image = images.first {
                            self.userImage = image
                        }
                    }, maxSelection: 1)
            }
            .navigationDestination(isPresented: $isShowingDetail) {
                UserDetailsView(userName: $userName, userImage: $userImage)
            }
            .onChange(of: userName) {
                UserDataManager.shared.saveUserName(userName)
            }
            .onChange(of: userImage) {
                if let image = userImage {
                    _ = UserDataManager.shared.saveUserImage(image)
                }
            }
        }
    }
}
