//  Step Into Vision - Labs
//
//  Title: Lab020
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 12/19/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab020: View {

    @State var subject: Entity?
    @State var collisionBeganUnfiltered: EventSubscription?
    @State var collisionBeganSubject: EventSubscription?

    var body: some View {
        RealityView { content, attachments in
            if let scene = try? await Entity(named: "Lab020Scene", in: realityKitContentBundle) {
                content.add(scene)
                subject = scene.findEntity(named: "StepSphereBlue")

                // This unfiltered event will fire twice. Once for each entity in the collision
                // Each will be entityA in their own version of the event, so we don't need the burse for entityB
                collisionBeganUnfiltered = content.subscribe(to: CollisionEvents.Began.self)  { collisionEvent in
                    print("Collision unfiltered \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")
                    collisionEvent.entityA.components[ParticleEmitterComponent.self]?.burst()

                }

                collisionBeganSubject = content
                    .subscribe(to: CollisionEvents.Began.self, on: subject)  { collisionEvent in
                        print("Collision Subject \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")
                        if let subject {
                            popupEntity(subject)
//                            if subject.position.y > 1.025 {
//                            } else {
//
//                            }
                        }
                    }
            }

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
        .modifier(DragGestureImproved())
    }

    func popupEntity(_ entity: Entity) {
        let transform = Transform(
            scale: SIMD3<Float>(repeating: 1),
            rotation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 0, 0)),
            translation: SIMD3<Float>(entity.position.x, entity.position.y + 0.05, entity.position.z)
        )

        let transform2 = Transform(
            scale: SIMD3<Float>(repeating: 1),
            rotation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 0, 0)),
            translation: SIMD3<Float>(entity.position.x, 1.0, entity.position.z)
        )

        entity
            .move(
                to: transform,
                relativeTo: entity.parent!,
                duration: 0.5,
                timingFunction: .easeInOut
            )
        entity
            .move(
                to: transform2,
                relativeTo: entity.parent!,
                duration: 1.0,
                timingFunction: .easeInOut
            )
    }

}

#Preview {
    Lab020()
}
