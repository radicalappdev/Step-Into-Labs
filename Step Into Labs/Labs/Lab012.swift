//  Step Into Vision - Labs
//
//  Title: Lab012
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 11/5/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab012: View {

    @State var leftHandTrackedEntity: Entity = {
        let handAnchor = AnchorEntity(.hand(.left, location: .palm))
        return handAnchor
    }()

    @State var rightHandTrackedEntity: Entity = {
        let handAnchor = AnchorEntity(.hand(.right, location: .palm))
        return handAnchor
    }()

    @State var orbIsActive: Bool = false

    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "Lab012Scene", in: realityKitContentBundle) {
                content.add(scene)
                content.add(leftHandTrackedEntity)
                content.add(rightHandTrackedEntity)
                

            }

        } update: { content, attachments in

        } attachments: {

        }
        .persistentSystemOverlays(.hidden)
        .gesture(tapGesture)
        .gesture(longPressGesture)
        .modifier(DragGestureImproved())
        .modifier(MagnifyGestureImproved())

    }

    var tapGesture: some Gesture {
        TapGesture(count: 2)
            .targetedToAnyEntity()

            .onEnded { value in
                

                let subject = value.entity
                subject.scale = .init(repeating: 1.0)

                if(value.entity.parent == leftHandTrackedEntity) {
                    // Move the subject from the anchor to the scene root
                    leftHandTrackedEntity.parent?.addChild(subject)
                    leftHandTrackedEntity.removeChild(subject)
                    // Set position back to default
                    subject.position = [1, 1, -1]

                } else {
                    // Attach the subject to the anchor
                    leftHandTrackedEntity.addChild(subject)
                    subject
                        .setPosition(
                            [0.12, 0.12, 0],
                            relativeTo: leftHandTrackedEntity
                        )
                }
            }
    }

    // A long press gesture that will toggle the opacity of the subject material
    var longPressGesture: some Gesture {
        LongPressGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                let subject = value.entity

                orbIsActive.toggle()

                if var mat = subject.components[ModelComponent.self]?.materials.first as? PhysicallyBasedMaterial {

                    mat.blending = .transparent(opacity: orbIsActive ? 0.2 : 1.0)
                    subject.components[ModelComponent.self]?.materials[0] = mat
                }

            }
    }

}

#Preview {
    Lab012()
}
