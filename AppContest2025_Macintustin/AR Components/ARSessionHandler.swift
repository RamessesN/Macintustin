/**
 @file ARSessionHandler.swift
 @project AppContest2025_Macintustin
 
 @brief Utility class for handling AR session events in the augmented reality view
 @details
   This file contains static methods to respond to AR session updates, particularly related to plane detection. It notifies the UI when horizontal planes are detected or updated.

 @author 赵禹惟
 @date 2025/07/02
 */

import SwiftUI
import ARKit

class ARSessionHandler {
    static func handleAnchorsAdded(_ anchors: [ARAnchor], isPlaneDetected: Binding<Bool>) {
        for anchor in anchors {
            if anchor is ARPlaneAnchor {
                DispatchQueue.main.async {
                    isPlaneDetected.wrappedValue = true
                }
            }
        }
    }

    static func handleAnchorsUpdated(_ anchors: [ARAnchor], isPlaneDetected: Binding<Bool>) {
        for anchor in anchors {
            if let planeAnchor = anchor as? ARPlaneAnchor,
               planeAnchor.planeExtent.width > 0,
               planeAnchor.planeExtent.height > 0 {
                DispatchQueue.main.async {
                    isPlaneDetected.wrappedValue = true
                }
            }
        }
    }
}
