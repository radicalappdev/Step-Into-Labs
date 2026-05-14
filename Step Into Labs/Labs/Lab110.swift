//  Step Into Vision - Labs
//
//  Title: Lab110
//
//  Subtitle: Curved Display Surface
//
//  Description: Using MeshDescriptor to create a curved surface.
//
//  Type: Volume
//
//  Featured: true
//
//  Created by Joseph Simpson on 5/14/26.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab110: View {
    @State private var draftWidth: Float = 1.05
    @State private var draftHeight: Float = 0.45
    @State private var committedWidth: Float = 1.05
    @State private var committedHeight: Float = 0.45

    private let panelName = "Curved Rounded Surface"
    private let sphereRadius: Float = 0.5
    private let horizontalSegments = 96
    private let middleVerticalSegments = 10
    private let cornerVerticalSegments = 44

    var body: some View {
        RealityView { content in
            let panel = Entity()
            panel.name = panelName
            configurePanel(panel)
            content.add(panel)
        } update: { content in
            guard let panel = content.entities.first(where: { $0.name == panelName }) else { return }
            configurePanel(panel)
        }
        .realityViewLayoutBehavior(.centered)
        .debugBorder3D(.white)
        .ornament(attachmentAnchor: .scene(.bottomFront), contentAlignment: .bottom) {
            controls
        }
    }

    private var controls: some View {
        VStack(alignment: .leading, spacing: 12) {
            sliderRow(
                title: "Width",
                value: $draftWidth,
                range: 0.45...1.35,
                onCommit: { committedWidth = draftWidth }
            )

            sliderRow(
                title: "Height",
                value: $draftHeight,
                range: 0.2...0.8,
                onCommit: { committedHeight = draftHeight }
            )
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .frame(width: 360)
        .glassBackgroundEffect()
    }

    private func sliderRow(
        title: String,
        value: Binding<Float>,
        range: ClosedRange<Float>,
        onCommit: @escaping () -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .fontWeight(.semibold)

                Spacer()

                Text(String(format: "%.2f", value.wrappedValue))
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }

            Slider(value: value, in: range) { isEditing in
                if !isEditing {
                    onCommit()
                }
            }
        }
    }

    private func configurePanel(_ panel: Entity) {
        guard let mesh = makeRoundedSphericalPanel(
            sphereRadius: sphereRadius,
            angularSize: [committedWidth, committedHeight],
            cornerRadius: min(committedWidth, committedHeight) * 0.18,
            horizontalSegments: horizontalSegments,
            middleVerticalSegments: middleVerticalSegments,
            cornerVerticalSegments: cornerVerticalSegments
        ) else { return }

        var material = UnlitMaterial(color: .stepGreen)
        material.blending = .transparent(opacity: 0.75)
        material.faceCulling = .none

        panel.components.set(ModelComponent(mesh: mesh, materials: [material]))
    }

    private func makeRoundedSphericalPanel(
        sphereRadius: Float,
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
                let direction = sphericalDirection(yaw: yaw, pitch: pitch)

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

        var descriptor = MeshDescriptor(name: panelName)
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
}

#Preview {
    Lab110()
}
