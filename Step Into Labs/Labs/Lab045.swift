//  Step Into Vision - Labs
//
//  Title: Lab045
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 4/6/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab045: View {
    var body: some View {
        RealityView { content in

            // Create the subject
            let subject = ModelEntity(
                mesh: .generateBox(size: 0.2),
                materials: [SimpleMaterial(color: .stepRed, isMetallic: false)]
            )

            // Set up components
            let collision = CollisionComponent(shapes: [.generateBox(size: .init(repeating: 0.2))])
            let input = InputTargetComponent()
            let hover = HoverEffectComponent()
            subject.components.set([collision, input, hover])

            // Add the subject to the scene
            content.add(subject)
        }
        .gesture(tap)

    }

    var tap: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                Task {

                    let spinAction = SpinAction(revolutions: 1,
                                                localAxis: [0, 1, 0],
                                                timingFunction: .easeInOut,
                                                isAdditive: false)

                    let spinAnimation = try AnimationResource
                        .makeActionAnimation(for: spinAction,
                                             duration: 1.0,
                                             bindTarget: .transform)


                    value.entity.playAnimation(spinAnimation)
                }

            }
    }
}

#Preview {
    Lab045()
}
