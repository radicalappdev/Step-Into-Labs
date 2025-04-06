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

    // Create the subject
    @State var subject: Entity = {
        let entity = ModelEntity(
            mesh: .generateBox(size: 0.2),
            materials: [SimpleMaterial(color: .stepRed, isMetallic: false)]
        )
        let collision = CollisionComponent(shapes: [.generateBox(size: .init(repeating: 0.2))])
        let input = InputTargetComponent()
        let hover = HoverEffectComponent()
        entity.components.set([collision, input, hover])
        entity.position.y = -0.3
        return entity
    }()

    var body: some View {
        RealityView { content in

            // Add the subject to the scene
            content.add(subject)
        }

        // Create a toolbar with a button to perform the action
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                HStack {
                    Button(action: {
                        spinSubject()
                    }, label: {
                        Text("Spin")
                    })
                    Button (action: {
                        emphasizeSubject()
                    }, label: {
                        Text("Emphasize")
                    })
                }
            })
        }

    }

    func spinSubject() {
        Task {
            // Create the action
            let spinAction = SpinAction(revolutions: 1,
                                        localAxis: [0, 1, 0],
                                        timingFunction: .easeInOut,
                                        isAdditive: false)

            // Use the action in an animation
            let spinAnimation = try AnimationResource.makeActionAnimation(for: spinAction,
                                                                          duration: 1,
                                                                          bindTarget: .transform)

            // Play the animation
            subject.playAnimation(spinAnimation)
        }
    }

    func emphasizeSubject() {
        Task {
            let action = EmphasizeAction(motionType: .bounce, style: .playful)

            let animation = try! AnimationResource.makeActionAnimation(for: action,
                                                                       duration: 1,
                                                                       bindTarget: .transform)
            subject.playAnimation(animation)
        }
    }

}

#Preview {
    Lab045()
}
