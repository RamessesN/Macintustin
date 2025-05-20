//
//  AugmentedRealityView.swift
//  AppContest2025_Macintustin
//
//  Created by 赵禹惟 on 2025/4/18.
//

import SwiftUI
import RealityKit
import ARKit

struct AugmentedRealityView: View {
    @State private var isPlainDetected = false
    @State private var isToggled = false

    var body: some View {
        ZStack {
            ARViewContainer(
                isPlainDetected: $isPlainDetected,
                isToggled: $isToggled
            )

            GeometryReader { geometry in
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(isPlainDetected ? .red : .red.opacity(0.5))
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }

            VStack {
                Spacer()

                Button(action: {
                    isToggled = true
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
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var isPlainDetected: Bool
    @Binding var isToggled: Bool

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        arView.session.run(config)
        arView.session.delegate = context.coordinator
        context.coordinator.arView = arView
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        if isPlainDetected && isToggled && !context.coordinator.anchorAdded {
            guard let modelEntity = try? ModelEntity.load(named: "MyModel") else {
                fatalError("Model Load Failed")
            }

            let anchorEntity = AnchorEntity(plane: .horizontal)
            anchorEntity.addChild(modelEntity)
            uiView.scene.anchors.append(anchorEntity)

            context.coordinator.anchorAdded = true
        }
    }

    class Coordinator: NSObject, ARSessionDelegate {
        var parent: ARViewContainer
        var arView: ARView?
        var anchorAdded = false

        init(parent: ARViewContainer) {
            self.parent = parent
        }

        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            for anchor in anchors {
                if anchor is ARPlaneAnchor {
                    DispatchQueue.main.async {
                        self.parent.isPlainDetected = true
                    }
                }
            }
        }
        
        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
            for anchor in anchors {
                if let planeAnchor = anchor as? ARPlaneAnchor {
                    if planeAnchor.planeExtent.width > 0 && planeAnchor.planeExtent.height > 0 {
                        DispatchQueue.main.async {
                            self.parent.isPlainDetected = true
                        }
                    }
                }
            }
        }
    }
}
