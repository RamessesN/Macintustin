/**
 @file ARViewContainer.swift
 @project AppContest2025_Macintustin
 
 @brief Container view for integrating RealityKit's ARView with SwiftUI
 @details
   This file implements a bridge between SwiftUI and the native ARKit/RealityKit framework by using `UIViewRepresentable`. It handles AR session configuration, plane detection, user interaction via gestures, and model placement logic.

 @author 赵禹惟
 @date 2025/5/16
 */

import SwiftUI
import RealityKit
import ARKit
import Combine
import CoreLocation

struct ARViewContainer: UIViewRepresentable {
    @Binding var isPlaneDetected: Bool
    @Binding var isToggled: Bool
    @Binding var selectedModelName: String
    @Binding var isCommenting: Bool
    @Binding var selectedModelEntity: ModelEntity?

    @ObservedObject var locationManager: LocationManager

    func makeCoordinator() -> Coordinator {
        Coordinator(
            parent: self,
            isPlaneDetected: $isPlaneDetected,
            isCommenting: $isCommenting,
            selectedModelEntity: $selectedModelEntity
        )
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        arView.session.run(config)
        arView.session.delegate = context.coordinator

        context.coordinator.arView = arView

        arView.scene.subscribe(to: SceneEvents.Update.self) { _ in
            let center = CGPoint(x: arView.bounds.midX, y: arView.bounds.midY)
            let results = arView.raycast(from: center, allowing: .estimatedPlane, alignment: .horizontal)
            DispatchQueue.main.async {
                self.isPlaneDetected = results.first != nil
            }
        }
        .store(in: &context.coordinator.cancellables)

        let gesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress(_:)))
        arView.addGestureRecognizer(gesture)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        guard isToggled else { return }
        ModelPlacementHandler.placeModel(
            in: uiView,
            modelName: selectedModelName,
            locationManager: locationManager,
            isToggled: $isToggled
        )
    }

    class Coordinator: NSObject, ARSessionDelegate {
        var parent: ARViewContainer
        var arView: ARView?
        var cancellables = Set<AnyCancellable>()
        
        var isPlaneDetectedBinding: Binding<Bool>
        var isCommentingBinding: Binding<Bool>
        var selectedModelEntityBinding: Binding<ModelEntity?>      

        init(parent: ARViewContainer,
             isPlaneDetected: Binding<Bool>,
             isCommenting: Binding<Bool>,
             selectedModelEntity: Binding<ModelEntity?>)
        {
            self.parent = parent
            self.isPlaneDetectedBinding = isPlaneDetected
            self.isCommentingBinding = isCommenting
            self.selectedModelEntityBinding = selectedModelEntity
        }

        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            ARSessionHandler.handleAnchorsAdded(anchors, isPlaneDetected: isPlaneDetectedBinding)
        }

        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
            ARSessionHandler.handleAnchorsUpdated(anchors, isPlaneDetected: isPlaneDetectedBinding)
        }


        func presentActionMenu(for modelEntity: ModelEntity) {
            guard let arView = arView else { return }

            let alert = UIAlertController(title: "Model Options", message: nil, preferredStyle: .actionSheet)

            alert.addAction(UIAlertAction(title: "Comment", style: .default) { _ in
                DispatchQueue.main.async {
                    self.selectedModelEntityBinding.wrappedValue = modelEntity
                    self.isCommentingBinding.wrappedValue = true
                }
            })

            alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
                if let anchor = self.findAnchor(for: modelEntity) {
                    anchor.removeFromParent()
                } else {
                    modelEntity.removeFromParent()
                }
            })

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            if let vc = arView.window?.rootViewController {
                vc.present(alert, animated: true)
            }
        }
    }
}
