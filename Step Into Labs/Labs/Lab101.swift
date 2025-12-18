//  Step Into Vision - Labs
//
//  Title: Lab101
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Featured:
//
//  Created by Joseph Simpson on 12/18/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab101: View {
    private enum ExtrusionExample: String, CaseIterable, Identifiable {
        case linear = "Linear"
        case tracePositions = "Trace Positions"
        case traceTransforms = "Trace Transforms"

        var id: String { rawValue }
    }

    @State private var example: ExtrusionExample = .tracePositions
    @State private var subject: ModelEntity?
    @State private var appliedExample: ExtrusionExample?

    var body: some View {
        RealityView { content in
            // Create and add the subject once.
            let entity = ModelEntity()
            subject = entity
            content.add(entity)

            // Initial build.
            await apply(example: example, to: entity)
            appliedExample = example
            spinSubject(entity: entity)
        }
        .onChange(of: example) { _, newValue in
            guard let subject else { return }
            guard appliedExample != newValue else { return }

            Task { @MainActor in
                await apply(example: newValue, to: subject)
                appliedExample = newValue
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament) {
                Picker("Extrusion", selection: $example) {
                    ForEach(ExtrusionExample.allCases) { item in
                        Text(item.rawValue).tag(item)
                    }
                }
                .pickerStyle(.menu)
            }
        }
        .realityViewLayoutBehavior(.centered)
    }

    @MainActor
    private func apply(example: ExtrusionExample, to entity: ModelEntity) async {
        // Materials
        let mat1 = SimpleMaterial(color: .stepGreen, roughness: 0.2, isMetallic: false)
        let mat2 = SimpleMaterial(color: .stepRed, roughness: 0.2, isMetallic: false)
        let mat3 = SimpleMaterial(color: .stepBlue, roughness: 0.2, isMetallic: false)
        let mat4 = SimpleMaterial(color: .stepBackgroundPrimary, roughness: 0.2, isMetallic: false)

        // Extrusion options
        var extrusionOptions = MeshResource.ShapeExtrusionOptions()
        switch example {
        case .linear:
            extrusionOptions.extrusionMethod = .linear(depth: 0.05) // in meters

        case .tracePositions:
            extrusionOptions.extrusionMethod = .tracePositions(
                arcTracePositions(count: 12)
            )

        case .traceTransforms:
            extrusionOptions.extrusionMethod = .traceTransforms(
                arcTraceMatrices(count: 24, startScale: .one, endScale: [2, 2, 2])
            )
        }

        extrusionOptions.chamferRadius = 0.01
        extrusionOptions.boundaryResolution = .uniformSegmentsPerSpan(segmentCount: 64)
        extrusionOptions.materialAssignment = .init(front: 0, back: 1, extrusion: 2, frontChamfer: 3, backChamfer: 3)

        // Generate mesh
        let mesh = try! await MeshResource(extruding: simplePath(), extrusionOptions: extrusionOptions)

        // Update the entity in-place (no swapping/removing required)
        entity.model = ModelComponent(mesh: mesh, materials: [mat1, mat2, mat3, mat4])
    }

    func arcTracePositions(
        count n: Int,
        radius: Float = 0.35,
        height: Float = 0.05,
        z: Float = 0
    ) -> [SIMD3<Float>] {
        guard n >= 2 else { return [] }

        let startX: Float = -0.25
        let endX: Float = 0.25

        return (0..<n).map { i in
            let t = Float(i) / Float(n - 1)              // 0 → 1
            let x = simd_mix(startX, endX, t)

            // Smooth arc using sine (peaks at center)
            let y = sin(t * .pi) * height

            return SIMD3<Float>(x, y, z)
        }
    }

    func arcTraceMatrices(
        count n: Int,
        height: Float = 0.05,
        x: Float = 0,
        startZ: Float = -0.25,
        endZ: Float = 0.25,
        startScale: SIMD3<Float> = .one,
        endScale: SIMD3<Float> = SIMD3<Float>(repeating: 1.12)
    ) -> [simd_float4x4] {
        guard n >= 2 else { return [] }

        return (0..<n).map { i in
            let t = Float(i) / Float(n - 1) // 0 → 1
            let z = simd_mix(startZ, endZ, t)

            // Smooth arc using sine (peaks at center)
            let y = sin(t * .pi) * height

            let translation = SIMD3<Float>(x, y, z)
            let scale = simd_mix(startScale, endScale, SIMD3<Float>(repeating: t))

            let transform = Transform(
                scale: scale,
                rotation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 1, 0)),
                translation: translation
            )

            return transform.matrix
        }
    }

    // Just a helper function to create a Path
    func simplePath() -> Path {
        let points = 5
        let outerRadius: CGFloat = 0.12
        let innerRadius: CGFloat = 0.05
        let center = CGPoint(x: 0, y: 0)

        var path = Path()
        let angleStep = .pi * 2 / CGFloat(points * 2)

        for i in 0..<(points * 2) {
            let radius = (i % 2 == 0) ? outerRadius : innerRadius
            let angle = CGFloat(i) * angleStep - .pi / 2
            let point = CGPoint(
                x: center.x + cos(angle) * radius,
                y: center.y + sin(angle) * radius
            )

            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }

        path.closeSubpath()
        return path
    }

    // A helper function to spin the subject to showcase the extrusion
    func spinSubject(entity: Entity) {
        Task {
            let action = SpinAction(revolutions: 1,
                                    localAxis: [-0.25, 1, 0.25],
                                    timingFunction: .easeInOut,
                                    isAdditive: false)
            let animation = try AnimationResource.makeActionAnimation(for: action,
                                                                      duration: 3,
                                                                      bindTarget: .transform,
                                                                      repeatMode: .autoReverse)
            entity.playAnimation(animation)
        }
    }
}

#Preview {
    Lab101()
}
