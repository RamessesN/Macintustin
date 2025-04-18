//
//  LocationDetailsView.swift
//  AppContest2025_Macintustin
//
//  Created by 赵禹惟 on 2025/4/17.
//

import SwiftUI
import MapKit

struct LocationDetailsView: View {
    @Binding var mapSelection: MKMapItem?
    @Binding var show: Bool
    @Binding var getDirections: Bool
    @Binding var routeDisplaying: Bool
    @Binding var route: MKRoute?
    @State private var localPhotos: [UIImage] = []
    @State private var mapView = MKMapView()
    @State private var currentIndex: Int = 0
    @State private var timer: Timer?
    @State private var showImagePicker = false
    @State private var selectedImages: [UIImage] = []
    @State private var showUploadConfirmation = false
    @State private var pendingImages: [UIImage] = []
    
    let cancelNavigation: () -> Void
    
    private let PhotoDatabase: [String: [String]] = [
        "Ocean University of China (West Coast Campus)": ["oucwest_1", "oucwest_2", "oucwest_3"],
        "Ocean University of China Xihaian Campus (West Gate)": ["oucwest_1", "oucwest_2", "oucwest_3"],
        "Ocean University of China West Coast Campus": ["oucwest_1", "oucwest_2", "oucwest_3"],
        "Haijun Park": ["haijunpark_1", "haijunpark_2", "haijunpark_3"],
        "Mangrove Tree Town Square": ["hongshulin_1", "hongshulin_2"]
    ]

    var body: some View {
        VStack {
            HStack {
                LocationDetailsHeaderView(
                    placemarkName: mapSelection?.placemark.name ?? "",
                    placemarkTitle: mapSelection?.placemark.title ?? ""
                )
                
                Spacer()
                
                HeartButtonView(placemarkName: mapSelection?.placemark.name ?? "")
            }
            
            PhotoCarouselView(
                currentIndex: $currentIndex,
                localPhotos: $localPhotos,
                showImagePicker: $showImagePicker
            )
            
            NavigationButtonsView(
                routeDisplaying: $routeDisplaying,
                show: $show,
                getDirections: $getDirections,
                mapSelection: mapSelection,
                cancelNavigation: cancelNavigation
            )
        }
        .onAppear {
            fetchPhotos()
            startTimer()
        }
        .onDisappear {
            stopTimer()
            currentIndex = 0
        }
        .onChange(of: mapSelection) { _, _ in
            fetchPhotos()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImages: $selectedImages) { images in
                pendingImages = images
                showUploadConfirmation = true
            }
        }
        .alert("Confirm Upload", isPresented: $showUploadConfirmation) {
            Button("Cancel", role: .cancel) {
                pendingImages = []
            }
            Button("Confirm") {
                saveUserPhotos(pendingImages)
                pendingImages = []
            }
        } message: {
            Text("Sure to upload these photos?")
        }
        .padding()
    }
}

extension LocationDetailsView {
    func saveUserPhotos(_ images: [UIImage]) {
        guard let placeName = mapSelection?.placemark.name else { return }
        
        for image in images {
            _ = PhotoStorage.shared.savePhoto(image, for: placeName, name: "")
        }
        
        fetchPhotos()
    }
    
    func fetchPhotos() {
        guard let placeName = mapSelection?.placemark.name else {
            localPhotos = []
            currentIndex = 0
            return
        }
        
        var fetchedPhotos: [UIImage] = []
        
        if let photoNames = PhotoDatabase[placeName] {
            for name in photoNames where !name.isEmpty {
                if let image = UIImage(named: name) {
                    fetchedPhotos.append(image)
                }
            }
        }
        
        let userPhotos = PhotoStorage.shared.loadPhotos(for: placeName)
        fetchedPhotos.append(contentsOf: userPhotos)
        
        localPhotos = fetchedPhotos
        currentIndex = 0
        
        if localPhotos.count > 1 {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    func startTimer() {
        guard localPhotos.count > 1 else {
            stopTimer()
            return
        }
        
        stopTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 0.5)) {
                    currentIndex = (currentIndex + 1) % localPhotos.count
                }
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
