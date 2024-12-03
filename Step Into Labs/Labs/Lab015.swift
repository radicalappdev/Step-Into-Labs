//  Step Into Vision - Labs
//
//  Title: Lab015
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 11/27/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab015: View {
    var body: some View {
        RealityView { content in
            // Load the scene from the Reality Kit bundle
            if let scene = try? await Entity(named: "JiggleLabs", in: realityKitContentBundle) {
                content.add(scene)

                // Lower the entire scene to the bottom of the volume
                scene.position.y = -0.4

                if let jiggle = scene.findEntity(named: "Jiggle") {
                    jiggle.components.set(PhysicsSimulationComponent())
                    jiggle.components.set(PhysicsJointsComponent())

                    let hingeOrientation = simd_quatf(from: [1, 0, 0], to: [0, 0, 1])
                    
                    // Get all balls in sequence
                    let balls = (1...6).compactMap { jiggle.findEntity(named: "ball\($0)") }
                    
                    // Create joints between consecutive balls
                    let joints = zip(balls, balls.dropFirst()).map { (ball1, ball2) -> PhysicsRevoluteJoint in
                        let pin1 = ball1.pins.set(
                            named: "ball\(ball1.name)_to_\(ball2.name)_hinge",
                            position: .zero,
                            orientation: hingeOrientation
                        )
                        
                        let pin2 = ball2.pins.set(
                            named: "ball\(ball2.name)_to_\(ball1.name)_hinge",
                            position: ball2.position(relativeTo: ball1),
                            orientation: hingeOrientation
                        )
                        
                        return PhysicsRevoluteJoint(pin0: pin1, pin1: pin2)
                    }
                    
                    // Add all joints to simulation
                    Task {
                        try joints.forEach { try $0.addToSimulation() }
                    }
                }
            }
        }
        .modifier(DragGestureImproved())
    }
}

