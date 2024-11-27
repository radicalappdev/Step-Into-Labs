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

                    let End_1 = jiggle.findEntity(named: "end1")!
                    let Sphere_1 = jiggle.findEntity(named: "ball1")!

                    let attachmentPin = End_1.pins.set(
                        named: "end_1_hinge",
                        position: .zero,
                        orientation: hingeOrientation
                    )

                    let relativeJointLocation = End_1.position(
                        relativeTo: Sphere_1
                    )


                    let ballPin = Sphere_1.pins.set(
                        named: "ball_hinge",
                        position: relativeJointLocation,
                        orientation: hingeOrientation
                    )

                    let revoluteJoint = PhysicsRevoluteJoint(pin0: attachmentPin, pin1: ballPin)
                    Task {

                        try revoluteJoint.addToSimulation()
                    }






                }
            }
        }
    }
}

#Preview {
    Lab015()
}
