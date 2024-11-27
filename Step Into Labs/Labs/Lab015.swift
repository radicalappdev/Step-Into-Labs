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

                    // Entities
                    let ball1 = jiggle.findEntity(named: "ball1")!
                    let ball2 = jiggle.findEntity(named: "ball2")!
                    let ball3 = jiggle.findEntity(named: "ball3")!
                    let ball4 = jiggle.findEntity(named: "ball4")!
                    let ball5 = jiggle.findEntity(named: "ball5")!
                    let ball6 = jiggle.findEntity(named: "ball6")!

                    // Pins and Joints for connections
                    // Connect ball1 to ball2
                    let ball1ToBall2Pin1 = ball1.pins.set(
                        named: "ball1_to_ball2_hinge",
                        position: .zero,
                        orientation: hingeOrientation
                    )

                    let ball1ToBall2Pin2 = ball2.pins.set(
                        named: "ball2_to_ball1_hinge",
                        position: ball2.position(relativeTo: ball1),
                        orientation: hingeOrientation
                    )

                    let joint1 = PhysicsRevoluteJoint(pin0: ball1ToBall2Pin1, pin1: ball1ToBall2Pin2)

                    // Connect ball2 to ball3
                    let ball2ToBall3Pin1 = ball2.pins.set(
                        named: "ball2_to_ball3_hinge",
                        position: .zero,
                        orientation: hingeOrientation
                    )

                    let ball2ToBall3Pin2 = ball3.pins.set(
                        named: "ball3_to_ball2_hinge",
                        position: ball3.position(relativeTo: ball2),
                        orientation: hingeOrientation
                    )

                    let joint2 = PhysicsRevoluteJoint(pin0: ball2ToBall3Pin1, pin1: ball2ToBall3Pin2)

                    // Connect ball3 to ball4
                    let ball3ToBall4Pin1 = ball3.pins.set(
                        named: "ball3_to_ball4_hinge",
                        position: .zero,
                        orientation: hingeOrientation
                    )

                    let ball3ToBall4Pin2 = ball4.pins.set(
                        named: "ball4_to_ball3_hinge",
                        position: ball4.position(relativeTo: ball3),
                        orientation: hingeOrientation
                    )

                    let joint3 = PhysicsRevoluteJoint(pin0: ball3ToBall4Pin1, pin1: ball3ToBall4Pin2)

                    // Connect ball4 to ball5
                    let ball4ToBall5Pin1 = ball4.pins.set(
                        named: "ball4_to_ball5_hinge",
                        position: .zero,
                        orientation: hingeOrientation
                    )

                    let ball4ToBall5Pin2 = ball5.pins.set(
                        named: "ball5_to_ball4_hinge",
                        position: ball5.position(relativeTo: ball4),
                        orientation: hingeOrientation
                    )

                    let joint4 = PhysicsRevoluteJoint(pin0: ball4ToBall5Pin1, pin1: ball4ToBall5Pin2)

                    // Connect ball5 to ball6
                    let ball5ToBall6Pin1 = ball5.pins.set(
                        named: "ball5_to_ball6_hinge",
                        position: .zero,
                        orientation: hingeOrientation
                    )

                    let ball5ToBall6Pin2 = ball6.pins.set(
                        named: "ball6_to_ball5_hinge",
                        position: ball6.position(relativeTo: ball5),
                        orientation: hingeOrientation
                    )

                    let joint5 = PhysicsRevoluteJoint(pin0: ball5ToBall6Pin1, pin1: ball5ToBall6Pin2)

                    // Add all joints to the simulation
                    Task {
                        try joint1.addToSimulation()
                        try joint2.addToSimulation()
                        try joint3.addToSimulation()
                        try joint4.addToSimulation()
                        try joint5.addToSimulation()
                    }
                }
            }
        }
        .modifier(DragGestureImproved())
    }
}

#Preview {
    Lab015()
}

#Preview {
    Lab015()
}
