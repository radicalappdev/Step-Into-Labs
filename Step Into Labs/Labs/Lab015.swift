//  Step Into Vision - Labs
//
//  Title: Lab015
//
//  Subtitle: Exploring Physics Joints
//
//  Description: Loading some entities and adding physics joints between them.
//
//  Type: Space
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
                let hingeOrientation = simd_quatf(from: [1, 0, 0], to: [0, 0, 1])


                // Example 1: Load two entities and join them together.
                if let simple = scene.findEntity(named: "Simple") {
                    simple.components.set(PhysicsSimulationComponent())
                    simple.components.set(PhysicsJointsComponent())

                    if let ballA = simple.findEntity(named: "a"),
                       let ballB = simple.findEntity(named: "b") {

                        // Create a pin for each ball
                        let pin1 = ballA.pins.set(
                            named: "demo_ballA_to_ballB_hinge",
                            position: .zero,
                            orientation: hingeOrientation
                        )
                        let pin2 = ballB.pins.set(
                            named: "demo_ballB_to_ballA_hinge",
                            position: ballB.position(relativeTo: ballA),
                            orientation: hingeOrientation
                        )

                        // Join the pins together
                        let simpleJoint = PhysicsRevoluteJoint(pin0: pin1, pin1: pin2)

                        // Add the join to the simulation
                        Task {
                            try simpleJoint.addToSimulation()
                        }
                    }
                }


                // Example 2: Load a chain of balls from the Reality Composer Pro file
                if let chain = scene.findEntity(named: "Chain") {
                    chain.components.set(PhysicsSimulationComponent())
                    chain.components.set(PhysicsJointsComponent())

                    // The balls are chrildren of the Chain entity. Each one named ball1, ball2, etc.
                    let balls = chain.children
                        .filter { $0.name.hasPrefix("ball") }
                        .sorted { Int($0.name.dropFirst(4))! < Int($1.name.dropFirst(4))! }

                    // We create connections by using two copies of the balls array.
                    // We drop the first element of the second array to shift the positions.
                    // Then we can zip the arrays to join them (ball1 to ball2, ball2 to ball3,...)
                    let chainJoints = zip(balls, balls.dropFirst()).map { (ball1, ball2) -> PhysicsRevoluteJoint in

                        // For each pair, create pins and join them together
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
                        try chainJoints.forEach { try $0.addToSimulation() }
                    }
                }
            }
        }
        .modifier(DragGestureImproved())
    }
}

