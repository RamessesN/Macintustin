/**
 @file LabelEntityBuilder.swift
 @project AppContest2025_Macintustin
 
 @brief Utility class for generating labeled UI elements in a RealityKit scene
 @details
   This class provides methods to create 3D text-based labels with background planes and layout positioning, suitable for use in augmented reality scenes. It supports text wrapping, truncation, and billboard behavior.

 @author 赵禹惟
 @date 2025/07/02
 */

import RealityKit

class LabelEntityBuilder {
    static func makeLabelEntity(placeName: String, placeDetail: String, modelEntity: Entity) -> Entity {
        let textEntity1 = makeTitleText(wrappedName: insertLineBreaks(every: 25, in: placeName))
        let textEntity2 = makeDetailText(wrappedDetail: truncateText(placeDetail, maxLength: 30))
        let comments = topComments(for: placeName)
        let textEntity3 = makeCommentText(comments: comments)

        let bounds1 = textEntity1.visualBounds(relativeTo: nil)
        let bounds2 = textEntity2.visualBounds(relativeTo: nil)
        let bounds3 = textEntity3.visualBounds(relativeTo: nil)

        let titleScale: Float = 1.1
        let detailScale: Float = 1.3
        let commentScale: Float = 1.2

        let height1 = bounds1.extents.y * titleScale
        let height2 = bounds2.extents.y * detailScale
        let height3 = bounds3.extents.y * commentScale

        let padding: Float = 0.05
        let spacing1: Float = 0.001 // title ➝ detail
        let spacing2: Float = 0.20 // detail ➝ comment

        let contentWidth = max(bounds1.extents.x, bounds2.extents.x, bounds3.extents.x)
        let totalWidth = contentWidth + padding * 2
        let totalHeight = height1 + spacing1 + height2 + spacing2 + height3

        var currentY: Float = totalHeight / 2 - padding

        currentY -= height1 / 2
        textEntity1.position = SIMD3<Float>(-totalWidth / 2 + padding, currentY, 0.01)
        currentY -= height1 / 2 + spacing1

        currentY -= height2 / 2
        textEntity2.position = SIMD3<Float>(-totalWidth / 2 + padding, currentY, 0.01)
        currentY -= height2 / 2 + spacing2

        currentY -= height3 / 2
        textEntity3.position = SIMD3<Float>(-totalWidth / 2 + padding, currentY, 0.01)

        let bgMesh = MeshResource.generatePlane(width: totalWidth, height: totalHeight * 1.3)
        let bgMaterial = SimpleMaterial(color: .white.withAlphaComponent(0.8), isMetallic: false)
        let backgroundEntity = ModelEntity(mesh: bgMesh, materials: [bgMaterial])
        backgroundEntity.position.z = 0.0

        let labelRoot = Entity()
        labelRoot.addChild(backgroundEntity)
        labelRoot.addChild(textEntity1)
        labelRoot.addChild(textEntity2)
        labelRoot.addChild(textEntity3)
        labelRoot.components.set(BillboardComponent())

        let modelBounds = modelEntity.visualBounds(relativeTo: nil)
        let offsetX = modelBounds.extents.x / 2 + totalWidth / 2 + 0.1
        labelRoot.position = SIMD3<Float>(offsetX, modelBounds.extents.y / 2, 0.05)

        return labelRoot
    }

    static func makeTitleText(wrappedName: String) -> ModelEntity {
        let mesh = MeshResource.generateText(
            wrappedName,
            extrusionDepth: 0.002,
            font: .boldSystemFont(ofSize: 0.15),
            containerFrame: .zero,
            alignment: .left,
            lineBreakMode: .byCharWrapping
        )
        let material = SimpleMaterial(color: .darkGray, isMetallic: true)
        return ModelEntity(mesh: mesh, materials: [material])
    }

    static func makeDetailText(wrappedDetail: String) -> ModelEntity {
        let mesh = MeshResource.generateText(
            wrappedDetail,
            extrusionDepth: 0.002,
            font: .systemFont(ofSize: 0.06),
            containerFrame: .zero,
            alignment: .left,
            lineBreakMode: .byCharWrapping
        )
        let material = SimpleMaterial(color: .systemGray, isMetallic: true)
        return ModelEntity(mesh: mesh, materials: [material])
    }

    static func makeCommentText(comments: [String]) -> ModelEntity {
        let commentText = comments.enumerated().map { "\($0 + 1). \($1)" }.joined(separator: "\n")
        let mesh = MeshResource.generateText(
            commentText,
            extrusionDepth: 0.001,
            font: .systemFont(ofSize: 0.08),
            containerFrame: .zero,
            alignment: .left,
            lineBreakMode: .byWordWrapping
        )
        let material = SimpleMaterial(color: .black, isMetallic: true)
        return ModelEntity(mesh: mesh, materials: [material])
    }

    static func truncateText(_ text: String, maxLength: Int) -> String {
        guard text.count > maxLength else { return text }
        let index = text.index(text.startIndex, offsetBy: max(0, maxLength - 1))
        return String(text[..<index]) + "..."
    }

    static func insertLineBreaks(every n: Int, in text: String) -> String {
        guard n > 0 else { return text }
        var result = ""
        for (i, char) in text.enumerated() {
            if i != 0 && i % n == 0 {
                result.append("\n")
            }
            result.append(char)
        }
        return result
    }

    private static func topComments(for placeName: String) -> [String] {
        if let exact = AppData.defaultComments[placeName] {
            return Array(exact.prefix(3))
        }

        let normalizedInput = normalize(placeName)

        for (key, comments) in AppData.defaultComments {
            let normalizedKey = normalize(key)
            if normalizedInput.contains(normalizedKey) || normalizedKey.contains(normalizedInput) {
                return Array(comments.prefix(3))
            }
        }

        return []
    }

    private static func normalize(_ string: String) -> String {
        return string
            .lowercased()
            .replacingOccurrences(of: "[^a-z0-9]", with: "", options: .regularExpression)
    }
}
