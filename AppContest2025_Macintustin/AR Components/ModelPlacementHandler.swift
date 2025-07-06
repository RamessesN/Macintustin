/**
 @file ModelPlacementHandler.swift
 @project AppContest2025_Macintustin
 
 @brief Utility class for placing 3D models in the AR scene based on detected surfaces and location
 @details
   This class provides methods to perform raycasting to detect surfaces, load and place 3D models from RealityKit, and attach location-based labels to them using reverse geocoding.

 @author 赵禹惟
 @date 2025/07/02
 */

import RealityKit
import CoreLocation
import SwiftUI

class ModelPlacementHandler {
    static func placeModel(
        in arView: ARView,
        modelName: String,
        locationManager: LocationManager,
        isToggled: Binding<Bool>
    ) {
        let center = CGPoint(x: arView.bounds.midX, y: arView.bounds.midY)
        let results = arView.raycast(from: center, allowing: .estimatedPlane, alignment: .horizontal)

        guard let firstResult = results.first else {
            print("Raycast failed: No surface found.")
            return
        }

        do {
            let modelEntity = try ModelEntity.load(named: modelName)
            modelEntity.name = modelName
            modelEntity.generateCollisionShapes(recursive: true)

            let anchor = AnchorEntity(world: firstResult.worldTransform)
            anchor.addChild(modelEntity)
            arView.scene.anchors.append(anchor)

            if let coordinate = locationManager.currentLocation {
                reverseGeocode(coordinate: coordinate) { placemark in
                    let placeName = placemark?.name ?? placemark?.locality ?? placemark?.country ?? modelName
                    let placeDetail = [
                        placemark?.thoroughfare,
                        placemark?.subLocality,
                        placemark?.locality,
                        placemark?.administrativeArea,
                        placemark?.country
                    ].compactMap { $0 }.joined(separator: ", ")

                    let labelEntity = LabelEntityBuilder.makeLabelEntity(
                        placeName: placeName,
                        placeDetail: placeDetail,
                        modelEntity: modelEntity
                    )
                    modelEntity.addChild(labelEntity)
                }
            }

            DispatchQueue.main.async {
                isToggled.wrappedValue = false
            }

        } catch {
            print("Failed to load model: $modelName), error: $error)")
        }
    }

    private static func reverseGeocode(coordinate: CLLocationCoordinate2D, completion: @escaping (CLPlacemark?) -> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first)
        }
    }
}
