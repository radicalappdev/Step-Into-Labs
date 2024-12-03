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
                    
                    // The balls are chrildren of the Jiggle entity. Each one named ball1, ball2, etc.
                    let balls = jiggle.children
                        .filter { $0.name.hasPrefix("ball") }
                        .sorted { Int($0.name.dropFirst(4))! < Int($1.name.dropFirst(4))! }
                    
                    // We create connections by using two copies of the balls array.
                    // We drop the first element of the second array to shift the positions.
                    // Then we can zip the arrays to join them (ball1 to ball2, ball2 to ball3,...)
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

