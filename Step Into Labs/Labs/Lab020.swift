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
    @State var collisionBeganSubjectScale: EventSubscription?

    var body: some View {
        RealityView { content in
            if let scene = try? await Entity(named: "Lab020Scene", in: realityKitContentBundle) {
                content.add(scene)
                subject = scene.findEntity(named: "StepSphereBlue")

                // Example 1: This unfiltered event will fire twice. Once for each entity in the collision
                // Each will be entityA in their own version of the event, so we don't need the burse for entityB
                collisionBeganUnfiltered = content.subscribe(to: CollisionEvents.Began.self)  { collisionEvent in
                    print("Collision unfiltered \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")
                    collisionEvent.entityA.components[ParticleEmitterComponent.self]?.burst()

                }

                // Example 2: Only trigger collisions on the subject.
                // Both the red and green spheres can collide with the subect to perform the bounce action
                collisionBeganSubject = content
                    .subscribe(to: CollisionEvents.Began.self, on: subject)  { collisionEvent in
                        print("Collision Subject Bounce \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")
                        if let subject {
                            bounceEntity(subject)
                        }
                    }

                // Example 3: the red sphere does one thing and the green does something else
                collisionBeganSubjectScale = content
                    .subscribe(to: CollisionEvents.Began.self, on: subject)  { collisionEvent in
                        print("Collision Subject Bounce \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")
                        if let subject {
                            if(collisionEvent.entityB.name == "StepSphereRed") {
                                scaleEntity(subject, scale: subject.scale.x - 0.1)
                            } else if (collisionEvent.entityB.name == "StepSphereGreen") {
                                scaleEntity(subject, scale: subject.scale.x + 0.1)
                            }
                        }
                    }
            }

        }
        .modifier(DragGestureImproved())
    }

    func bounceEntity(_ entity: Entity) {
        let transform = Transform(
            scale: SIMD3<Float>(repeating: entity.scale.x),
            rotation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 0, 0)),
            translation: SIMD3<Float>(entity.position.x, entity.position.y + 0.05, entity.position.z)
        )

        let transform2 = Transform(
            scale: SIMD3<Float>(repeating: entity.scale.x),
            rotation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 0, 0)),
            translation: SIMD3<Float>(entity.position.x, 1.0, entity.position.z)
        )

        entity.move(
            to: transform,
            relativeTo: entity.parent!,
            duration: 0.5,
            timingFunction: .easeIn
        )

        Timer.scheduledTimer(withTimeInterval: 0.45, repeats: false) { _ in
            entity.move(
                to: transform2,
                relativeTo: entity.parent!,
                duration: 0.3,
                timingFunction: .easeOut
            )
        }
    }

    func scaleEntity(_ entity: Entity, scale: Float) {
        let transform = Transform(
            scale: SIMD3<Float>(repeating: scale),
            rotation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 0, 0)),
            translation: SIMD3<Float>(entity.position.x, entity.position.y, entity.position.z)
        )

        entity.move(
            to: transform,
            relativeTo: entity.parent!,
            duration: 0.5,
            timingFunction: .easeInOut
        )
    }

}

#Preview {
    Lab020()
}
