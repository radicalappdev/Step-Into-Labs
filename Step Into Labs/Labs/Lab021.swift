//  Step Into Vision - Labs
//
//  Title: Lab021
//
//  Subtitle: Collision Triggers with AnchorEntity Hands?
//
//  Description: Do collision triggers fire from hand anchored entities without ARKit?
//
//  Type: Space
//
//  Created by Joseph Simpson on 12/19/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab021: View {
    @State var subject: Entity?
    @State var collisionBeganUnfiltered: EventSubscription?

    @State var leftHandTrackedEntity: Entity = {
        let handAnchor = AnchorEntity(.hand(.left, location: .palm))
        return handAnchor
    }()

    var body: some View {
        RealityView { content in
            if let scene = try? await Entity(named: "Lab020Scene", in: realityKitContentBundle) {
                content.add(scene)
                content.add(leftHandTrackedEntity)
                subject = scene.findEntity(named: "StepSphereBlue")

                collisionBeganUnfiltered = content.subscribe(to: CollisionEvents.Began.self)  { collisionEvent in
                    print("Collision unfiltered \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")
                    collisionEvent.entityA.components[ParticleEmitterComponent.self]?.burst()

                }
            }
        }
        .gesture(tapGesture)
        .modifier(DragGestureImproved())
    }

    var tapGesture: some Gesture {
        TapGesture(count: 2)
            .targetedToAnyEntity()

            .onEnded { value in
                let selected = value.entity
                guard (selected.name == "StepSphereRed") else {return}

                if(value.entity.parent == leftHandTrackedEntity) {
                    leftHandTrackedEntity.parent?.addChild(selected)
                    leftHandTrackedEntity.removeChild(selected)
                    selected.position = [-0.3, 1, -1]

                } else {
                    leftHandTrackedEntity.addChild(selected)
                    selected
                        .setPosition(
                            [0, 0.1, 0],
                            relativeTo: leftHandTrackedEntity
                        )
                }
            }
    }


}

#Preview {
    Lab021()
}
