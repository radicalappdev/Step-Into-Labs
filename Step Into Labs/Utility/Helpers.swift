//
//  Helpers.swift
//  Step Into Labs
//
//  Created by Joseph Simpson on 10/3/24.
//

import SwiftUI

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
