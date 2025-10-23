//
//  Helpers.swift
//  Step Into Labs
//
//  Created by Joseph Simpson on 10/3/24.
//

import SwiftUI
import RealityKit

extension Date {
    init(_ dateString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        self = dateFormatter.date(from: dateString) ?? Date()
    }
}

/// Adapted from Example Code 010
// TODO: make a gesture library that I can use in the labs.
struct DragGestureImproved: ViewModifier {

    @State var isDragging: Bool = false
    @State var initialPosition: SIMD3<Float> = .zero

    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture()
                    .targetedToAnyEntity()
                    .onChanged { value in

                        // We we start the gesture, cache the entity position
                        if !isDragging {
                            isDragging = true
                            initialPosition = value.entity.position
                        }

                        // Calculate vector by which to move the entity
                        let movement = value.convert(value.gestureValue.translation3D, from: .local, to: .scene)

                        // Add the initial position and the movement to get the new position
                        value.entity.position = initialPosition + movement

                    }
                    .onEnded { value in
                        // Clean up when the gesture has ended
                        isDragging = false
                        initialPosition = .zero
                    }
            )

    }
}


struct MagnifyGestureImproved: ViewModifier {
    
    @State var isScaling: Bool = false
    @State var initialScale: SIMD3<Float> = .init(repeating: 1.0)
    
    func body(content: Content) -> some View {
        content
            .gesture(
                MagnifyGesture()
                    .targetedToAnyEntity()
                    .onChanged { value in
                        // Cache the entity's initial scale when the gesture starts
                        if !isScaling {
                            isScaling = true
                            initialScale = value.entity.scale
                        }
                        
                        // Get the magnification from the gesture
                        let magnification = Float(value.magnification)
                        
                        let minScale: Float = 0.25
                        let maxScale: Float = 3
                        
                        // Multiply the magnification by the initial scale to get the new scale
                        // Clamp scale values for each axis independently
                        let newScaleX = min(max(initialScale.x * magnification, minScale), maxScale)
                        let newScaleY = min(max(initialScale.y * magnification, minScale), maxScale)
                        let newScaleZ = min(max(initialScale.z * magnification, minScale), maxScale)
                        
                        // Apply the clamped scale to the entity
                        value.entity.setScale(
                            .init(x: newScaleX, y: newScaleY, z: newScaleZ),
                            relativeTo: value.entity.parent!
                        )
                    }
                
                    .onEnded { value in
                        // Clean up when the gesture has ended
                        isScaling = false
                        initialScale = .init(repeating: 1.0)
                    }
            )
        
    }
}

struct RotateGesture3DImproved: ViewModifier {

    @State var isRotating: Bool = false
    @State var initialOrientation:simd_quatf = simd_quatf(
        vector: .init(repeating: 0.0)
    )

    func body(content: Content) -> some View {
        content
            .gesture(
                RotateGesture3D(constrainedToAxis: .y)
                    .targetedToAnyEntity()
                    .onChanged { value in

                        // Cache the entity's initial orientation when the gesture starts
                        if !isRotating {
                            isRotating = true
                            initialOrientation = value.entity.transform.rotation
                        }

                        let rotation = value.rotation
                        let rotationTransform = Transform(AffineTransform3D(rotation: rotation))

                        // Multiply the initial orientation by the gesture rotation
                        value.entity.transform.rotation = initialOrientation * rotationTransform.rotation

                    }
                    .onEnded { value in
                        // Clean up when the gesture has ended
                        isRotating = false
                        initialOrientation = simd_quatf(
                            vector: .init(repeating: 0.0)
                        )
                    }
            )
    }
}


struct ScaleAndRotateGesture: ViewModifier {

    @State var isActive: Bool = false
    @State var initialScale: SIMD3<Float> = .init(repeating: 1.0)
    @State var initialOrientation:simd_quatf = simd_quatf(
        vector: .init(repeating: 0.0)
    )

    func body(content: Content) -> some View {
        content
            .gesture(
                RotateGesture3D(constrainedToAxis: .y)
                    .simultaneously(with: MagnifyGesture())
                    .targetedToAnyEntity()
                    .onChanged { value in

                        // Cache the entity's initial scale and orientation when the gesture starts
                        if !isActive {
                            isActive = true
                            initialScale = value.entity.scale
                            initialOrientation = value.entity.transform.rotation
                        }

                        // Get the rotationa and magnification values
                        if let rotation = value.first?.rotation, let magnification = value.second?.magnification {


                            // Handle rotation (see exaple 012)
                            let rotationTransform = Transform(AffineTransform3D(rotation: rotation))
                            value.entity.transform.rotation = initialOrientation * rotationTransform.rotation

                            // Handle scale (see example 011)
                            let magnificationF = Float(magnification) // convert from CGFloat to Float...
                            let minScale: Float = 0.25
                            let maxScale: Float = 3
                            let newScaleX = min(max(initialScale.x * magnificationF, minScale), maxScale)
                            let newScaleY = min(max(initialScale.y * magnificationF, minScale), maxScale)
                            let newScaleZ = min(max(initialScale.z * magnificationF, minScale), maxScale)
                            value.entity.setScale(
                                .init(x: newScaleX, y: newScaleY, z: newScaleZ),
                                relativeTo: value.entity.parent!
                            )
                        }

                    }
                    .onEnded { value in
                        // Clean up when the gesture has ended
                        isActive = false
                        initialScale = .init(repeating: 1.0)
                        initialOrientation = simd_quatf(
                            vector: .init(repeating: 0.0)
                        )

                    }
            )
    }

}

/// See WWDC 2025 Session: Meet SwiftUI spatial layout
/// https://developer.apple.com/videos/play/wwdc2025/273
extension View {
    func debugBorder3D(_ color: Color) -> some View {
        spatialOverlay {
            ZStack {
                Color.clear.border(color, width: 4)
                ZStack {
                    Color.clear.border(color, width: 4)
                    Spacer()
                    Color.clear.border(color, width: 4)
                }
                .rotation3DLayout(.degrees(90), axis: .y)
                Color.clear.border(color, width: 4)
            }
        }
    }
}

// As a view instead of a modifier

func debugBorder3DView(_ color: Color) -> some View {
    ZStack {
        Color.clear.border(color, width: 4)
        ZStack {
            Color.clear.border(color, width: 4)
            Spacer()
            Color.clear.border(color, width: 4)
        }
        .rotation3DLayout(.degrees(90), axis: .y)
        Color.clear.border(color, width: 4)
    }
}


// Adapted from Example 051 - Spatial SwiftUI: Model3D
struct ModelViewSimple: View {

    @State var name: String = ""
    let bundle: Bundle

    var body: some View {
        Model3D(named: name, bundle: bundle)
        { phase in
            if let model = phase.model {
                model
                    .resizable()
                    .scaledToFit3D()
            } else if phase.error != nil {
                Text("Could not load model \(name).")
            } else {
                ProgressView()
            }
        }
    }
}

// Add with Lab 092

extension RealityViewContent {
    /// Traverses all entities in a RealityView and adds a `ManipulationComponent`
    /// to any entity that already has an `InputTargetComponent` that does not already have one.
    func addManipulationToInputTargets() async {
        await MainActor.run {
            var stack = Array(self.entities)
            while let entity = stack.popLast() {
                if entity.components.has(InputTargetComponent.self) &&
                    !entity.components.has(ManipulationComponent.self) {
                    entity.components.set(ManipulationComponent())
                }
                stack.append(contentsOf: entity.children)
            }
        }
    }
}
