/**
 @file AugmentedRealityView.swift
 @project AppContest2025_Macintustin
 
 @brief Main view for the augmented reality experience
 @details
   This file defines the SwiftUI view responsible for displaying and interacting with AR content. It integrates an AR view container, model selection UI, and location services.
 
 @author 赵禹惟
 @date 2025/5/16
 */

import SwiftUI
import RealityFoundation

struct AugmentedRealityView: View {
    @State private var isPlaneDetected = false
    @State private var isToggled = false
    @State private var selectedModelName = "Drummer"
    @State private var isCommenting = false
    @State private var selectedModelEntity: ModelEntity?
    @StateObject private var locationManager = LocationManager()

    let availableModels = ["Drummer", "RocketToy", "ToyBiplane"]

    var body: some View {
        ZStack {
            ARViewContainer(
                isPlaneDetected: $isPlaneDetected,
                isToggled: $isToggled,
                selectedModelName: $selectedModelName,
                isCommenting: $isCommenting,
                selectedModelEntity: $selectedModelEntity,
                locationManager: locationManager
            )
            .sheet(isPresented: $isCommenting) {
                if let model = selectedModelEntity {
                    let placeName = model.name
                    CommentView(
                        placemarkName: placeName,
                        initialComment: fetchInitialComment(for: placeName)
                    )
                }
            }

            GeometryReader { geometry in
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(isPlaneDetected ? .red : .red.opacity(0.5))
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }

            VStack {
                Spacer()

                Picker("Select Model", selection: $selectedModelName) {
                    ForEach(availableModels, id: \.self) { model in
                        Text(model).tag(model)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(8)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .fixedSize()

                Button(action: {
                    isToggled.toggle()
                }) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(.gray)
                        .padding()
                }
                .zIndex(1)
                .padding(.bottom, 10)
            }
        }
        .onAppear {
            locationManager.requestLocation()
        }
    }
}

extension AugmentedRealityView {
    func fetchInitialComment(for placeName: String) -> String {
        let key = "comments_\(placeName)"
        let comments = UserDefaults.standard.stringArray(forKey: key) ?? []
        return comments.last ?? ""
    }
}
