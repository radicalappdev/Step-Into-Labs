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
                    let End_1 = jiggle.findEntity(named: "end1")!
                    let Sphere_1 = jiggle.findEntity(named: "ball1")!
                    let Sphere_2 = jiggle.findEntity(named: "ball2")!
                    let Sphere_3 = jiggle.findEntity(named: "ball3")!
                    let End_2 = jiggle.findEntity(named: "end2")!

                    // Pins and Joints
                    let attachmentPin1 = End_1.pins.set(
                        named: "end_1_hinge",
                        position: .zero,
                        orientation: hingeOrientation
                    )

                    let relativeJointLocation1 = End_1.position(
                        relativeTo: Sphere_1
                    )

                    let ballPin1 = Sphere_1.pins.set(
                        named: "ball_1_hinge",
                        position: relativeJointLocation1,
                        orientation: hingeOrientation
                    )

                    let joint1 = PhysicsRevoluteJoint(pin0: attachmentPin1, pin1: ballPin1)

                    // Connect ball1 to ball2
                    let relativeJointLocation2 = Sphere_1.position(
                        relativeTo: Sphere_2
                    )

                    let ballPin2_1 = Sphere_1.pins.set(
                        named: "ball_1_to_2_hinge",
                        position: .zero,
                        orientation: hingeOrientation
                    )

                    let ballPin2_2 = Sphere_2.pins.set(
                        named: "ball_2_hinge",
                        position: relativeJointLocation2,
                        orientation: hingeOrientation
                    )

                    let joint2 = PhysicsRevoluteJoint(pin0: ballPin2_1, pin1: ballPin2_2)

                    // Connect ball2 to ball3
                    let relativeJointLocation3 = Sphere_2.position(
                        relativeTo: Sphere_3
                    )

                    let ballPin3_1 = Sphere_2.pins.set(
                        named: "ball_2_to_3_hinge",
                        position: .zero,
                        orientation: hingeOrientation
                    )

                    let ballPin3_2 = Sphere_3.pins.set(
                        named: "ball_3_hinge",
                        position: relativeJointLocation3,
                        orientation: hingeOrientation
                    )

                    let joint3 = PhysicsRevoluteJoint(pin0: ballPin3_1, pin1: ballPin3_2)

                    // Connect ball3 to end2
                    let relativeJointLocation4 = Sphere_3.position(
                        relativeTo: End_2
                    )

                    let ballPin4_1 = Sphere_3.pins.set(
                        named: "ball_3_to_end2_hinge",
                        position: .zero,
                        orientation: hingeOrientation
                    )

                    let attachmentPin2 = End_2.pins.set(
                        named: "end_2_hinge",
                        position: relativeJointLocation4,
                        orientation: hingeOrientation
                    )

                    let joint4 = PhysicsRevoluteJoint(pin0: ballPin4_1, pin1: attachmentPin2)

                    // Add all joints to the simulation
                    Task {
                        try joint1.addToSimulation()
                        try joint2.addToSimulation()
                        try joint3.addToSimulation()
                        try joint4.addToSimulation()
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
