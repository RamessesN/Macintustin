/**
 @file ImagePicker.swift
 @project AppContest2025_Macintustin
 
 @brief A wrapper for PHPickerViewController to select multiple images from the user's photo library.
 @details
  ImagePicker is a `UIViewControllerRepresentable` SwiftUI component that presents the system photo picker (`PHPickerViewController`) and allows users to select one or more images (up to a defined limit, default 3).
 
 @author 赵禹惟
 @date 2025/4/18
 */

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    @Environment(\.presentationMode) var presentationMode
    
    var didFinishPicking: ([UIImage]) -> Void
    var maxSelection: Int = 3
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = maxSelection
        configuration.preferredAssetRepresentationMode = .current
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            
            guard !results.isEmpty else { return }
            
            var processedImages = [UIImage]()
            let dispatchGroup = DispatchGroup()
            
            for result in results {
                dispatchGroup.enter()
                
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                    guard self != nil else { return }
                    
                    if let image = object as? UIImage {
                        if let pngData = image.pngData(), let pngImage = UIImage(data: pngData) {
                            DispatchQueue.main.async {
                                processedImages.append(pngImage)
                                dispatchGroup.leave()
                            }
                            return
                        }
                    }
                    
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.parent.selectedImages = processedImages
                self.parent.didFinishPicking(processedImages)
            }
        }
    }
}
