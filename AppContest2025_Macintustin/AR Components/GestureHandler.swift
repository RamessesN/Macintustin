/**
 @file GestureHandler.swift
 @project AppContest2025_Macintustin
 
 @brief Handles user gesture interactions within the AR view
 @details
   This file extends the `ARViewContainer.Coordinator` class to support long-press gestures for interacting with 3D entities in the AR scene. It provides functionality to detect taps on models and present a deletion confirmation alert.

 @author 赵禹惟
 @date 2025/07/02
 */

import UIKit
import RealityKit
import SwiftUI

extension ARViewContainer.Coordinator {
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began, let arView = arView else { return }

        let location = gesture.location(in: arView)
        if let entity = arView.entity(at: location),
           let modelEntity = entity as? ModelEntity {
            presentActionMenu(for: modelEntity)
        }
    }

    func findAnchor(for entity: Entity) -> AnchorEntity? {
        var current: Entity? = entity
        while let parent = current?.parent {
            if let anchor = parent as? AnchorEntity {
                return anchor
            }
            current = parent
        }
        return nil
    }

    func presentActionMenu(for entity: Entity) {
        guard let arView = arView else { return }

        let alert = UIAlertController(title: "Model Options", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Comment", style: .default) { _ in
            if let modelEntity = entity as? ModelEntity {
                DispatchQueue.main.async {
                    self.parent.selectedModelEntity = modelEntity
                    self.parent.isCommenting = true
                }
            }
        })

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            if let anchor = self.findAnchor(for: entity) {
                anchor.removeFromParent()
            } else {
                entity.removeFromParent()
            }
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        if let vc = arView.window?.rootViewController {
            vc.present(alert, animated: true)
        }
    }
}
