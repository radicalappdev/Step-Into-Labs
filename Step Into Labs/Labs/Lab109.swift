//  Step Into Vision - Labs
//
//  Title: Lab109
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Featured:
//
//  Created by Joseph Simpson on 5/12/26.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab109: View {
    @State private var subscriptions = [EventSubscription]()

    private let sphereCenterHeight: Float = 1.7
    private let panelAngularWidth: Float = 0.7
    private let panelAspectRatio: Float = 21 / 9
    private let panelCornerRadius: Float = 0.06
    private let horizontalSegments = 96
    private let middleVerticalSegments = 10
    private let cornerVerticalSegments = 44

    private var panelAngularSize: SIMD2<Float> {
        [panelAngularWidth, panelAngularWidth / panelAspectRatio]
    }

    private var panels: [PanelConfiguration] {
        [
            PanelConfiguration(name: "Group A 01", radius: 2.5, angularCenter: [0.00, 0.08], color: .cyan, angularVelocity: 0.055),
            PanelConfiguration(name: "Group A 02", radius: 2.9, angularCenter: [1.10, 0.34], color: .cyan, angularVelocity: -0.041),
            PanelConfiguration(name: "Group A 03", radius: 3.2, angularCenter: [-1.22, -0.18], color: .cyan, angularVelocity: 0.034),
            PanelConfiguration(name: "Group A 04", radius: 3.6, angularCenter: [2.46, 0.14], color: .cyan, angularVelocity: -0.062),

            PanelConfiguration(name: "Group B 01", radius: 2.7, angularCenter: [-0.62, 0.38], color: .systemTeal, angularVelocity: 0.047),
            PanelConfiguration(name: "Group B 02", radius: 3.1, angularCenter: [0.78, -0.32], color: .systemTeal, angularVelocity: -0.029),
            PanelConfiguration(name: "Group B 03", radius: 3.4, angularCenter: [-2.28, 0.24], color: .systemTeal, angularVelocity: 0.068),
            PanelConfiguration(name: "Group B 04", radius: 3.8, angularCenter: [3.04, -0.16], color: .systemTeal, angularVelocity: -0.036),

            PanelConfiguration(name: "Group C 01", radius: 2.6, angularCenter: [0.42, 0.52], color: .systemIndigo, angularVelocity: 0.025),
            PanelConfiguration(name: "Group C 02", radius: 3.0, angularCenter: [-0.98, -0.46], color: .systemIndigo, angularVelocity: -0.052),
            PanelConfiguration(name: "Group C 03", radius: 3.5, angularCenter: [1.82, -0.06], color: .systemIndigo, angularVelocity: 0.039),
            PanelConfiguration(name: "Group C 04", radius: 3.9, angularCenter: [-2.86, 0.42], color: .systemIndigo, angularVelocity: -0.071)
        ]
    }

    var body: some View {
        RealityView { content in
            var rotatingPanels: [(entity: Entity, angularVelocity: Float)] = []

            for configuration in panels {
                guard let panelMesh = makeRoundedSphericalPanel(
                    sphereRadius: configuration.radius,
                    angularCenter: configuration.angularCenter,
                    angularSize: panelAngularSize,
                    cornerRadius: panelCornerRadius,
                    horizontalSegments: horizontalSegments,
                    middleVerticalSegments: middleVerticalSegments,
                    cornerVerticalSegments: cornerVerticalSegments
                ) else { continue }

                var material = UnlitMaterial(color: configuration.color)
                material.blending = .transparent(opacity: 0.65)
                material.faceCulling = .none

                let panel = ModelEntity(mesh: panelMesh, materials: [material])
                panel.name = configuration.name
                panel.position.y = sphereCenterHeight
                content.add(panel)

                rotatingPanels.append((panel, configuration.angularVelocity))
            }

            subscriptions.append(content.subscribe(to: SceneEvents.Update.self) { event in
                for rotatingPanel in rotatingPanels {
                    let rotation = simd_quatf(
                        angle: Float(event.deltaTime) * rotatingPanel.angularVelocity,
                        axis: [0, 1, 0]
                    )

                    rotatingPanel.entity.orientation = rotation * rotatingPanel.entity.orientation
                }
            })
        }
    }

    private func makeRoundedSphericalPanel(
        sphereRadius: Float,
        angularCenter: SIMD2<Float>,
        angularSize: SIMD2<Float>,
        cornerRadius: Float,
        horizontalSegments: Int,
        middleVerticalSegments: Int,
        cornerVerticalSegments: Int
    ) -> MeshResource? {
        let halfWidth = angularSize.x / 2
        let halfHeight = angularSize.y / 2
        let cornerRadius = min(cornerRadius, halfWidth, halfHeight)
        let innerHalfWidth = halfWidth - cornerRadius
        let innerHalfHeight = halfHeight - cornerRadius
        let pitchSamples = roundedPanelPitchSamples(
            halfHeight: halfHeight,
            innerHalfHeight: innerHalfHeight,
            middleSegments: middleVerticalSegments,
            cornerSegments: cornerVerticalSegments
        )

        var positions: [SIMD3<Float>] = []
        var normals: [SIMD3<Float>] = []
        var textureCoordinates: [SIMD2<Float>] = []
        var triangleIndices: [UInt32] = []

        for pitch in pitchSamples {
            let v = (pitch + halfHeight) / (halfHeight * 2)
            let rowHalfWidth = rowWidth(
                forPitch: pitch,
                halfWidth: halfWidth,
                innerHalfWidth: innerHalfWidth,
                innerHalfHeight: innerHalfHeight,
                cornerRadius: cornerRadius
            )

            for column in 0...horizontalSegments {
                let u = Float(column) / Float(horizontalSegments)
                let yaw = mix(-rowHalfWidth, rowHalfWidth, t: u)
                let direction = sphericalDirection(
                    yaw: yaw + angularCenter.x,
                    pitch: pitch + angularCenter.y
                )

                positions.append(direction * sphereRadius)
                normals.append(-direction)
                textureCoordinates.append([u, 1 - v])
            }
        }

        let rowVertexCount = horizontalSegments + 1
        let rowCount = pitchSamples.count

        for row in 0..<(rowCount - 1) {
            for column in 0..<horizontalSegments {
                let upperLeft = UInt32(row * rowVertexCount + column)
                let upperRight = upperLeft + 1
                let lowerLeft = UInt32((row + 1) * rowVertexCount + column)
                let lowerRight = lowerLeft + 1

                triangleIndices.append(contentsOf: [
                    upperLeft, lowerLeft, upperRight,
                    upperRight, lowerLeft, lowerRight
                ])
            }
        }

        var descriptor = MeshDescriptor(name: "Rounded Spherical Panel")
        descriptor.positions = MeshBuffers.Positions(positions)
        descriptor.normals = MeshBuffers.Normals(normals)
        descriptor.textureCoordinates = MeshBuffers.TextureCoordinates(textureCoordinates)
        descriptor.primitives = .triangles(triangleIndices)

        return try? MeshResource.generate(from: [descriptor])
    }

    private func roundedPanelPitchSamples(
        halfHeight: Float,
        innerHalfHeight: Float,
        middleSegments: Int,
        cornerSegments: Int
    ) -> [Float] {
        var samples: [Float] = []
        let middleSegments = max(1, middleSegments)
        let cornerSegments = max(1, cornerSegments)

        appendPitchSamples(
            to: &samples,
            from: -halfHeight,
            to: -innerHalfHeight,
            segments: cornerSegments,
            includesStart: true
        )

        appendPitchSamples(
            to: &samples,
            from: -innerHalfHeight,
            to: innerHalfHeight,
            segments: middleSegments,
            includesStart: false
        )

        appendPitchSamples(
            to: &samples,
            from: innerHalfHeight,
            to: halfHeight,
            segments: cornerSegments,
            includesStart: false
        )

        return samples
    }

    private func appendPitchSamples(
        to samples: inout [Float],
        from start: Float,
        to end: Float,
        segments: Int,
        includesStart: Bool
    ) {
        let firstIndex = includesStart ? 0 : 1

        for index in firstIndex...segments {
            let t = Float(index) / Float(segments)
            samples.append(mix(start, end, t: t))
        }
    }

    private func rowWidth(
        forPitch pitch: Float,
        halfWidth: Float,
        innerHalfWidth: Float,
        innerHalfHeight: Float,
        cornerRadius: Float
    ) -> Float {
        let absolutePitch = abs(pitch)

        guard absolutePitch > innerHalfHeight else {
            return halfWidth
        }

        let cornerY = absolutePitch - innerHalfHeight
        return innerHalfWidth + sqrt(max(0, cornerRadius * cornerRadius - cornerY * cornerY))
    }

    private func sphericalDirection(yaw: Float, pitch: Float) -> SIMD3<Float> {
        let cosPitch = cos(pitch)

        return normalize([
            sin(yaw) * cosPitch,
            sin(pitch),
            -cos(yaw) * cosPitch
        ])
    }

    private func mix(_ start: Float, _ end: Float, t: Float) -> Float {
        start + (end - start) * t
    }

    private struct PanelConfiguration {
        let name: String
        let radius: Float
        let angularCenter: SIMD2<Float>
        let color: UIColor
        let angularVelocity: Float
    }
}

#Preview {
    Lab109()
}
