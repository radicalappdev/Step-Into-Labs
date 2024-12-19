//  Step Into Vision - Labs
//
//  Title: Lab020
//
//  Subtitle: Exploring Collision Triggers
//
//  Description: Starting with simple triggers to perform actions in a scene.
//
//  Type: Space
//
//  Created by Joseph Simpson on 12/19/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab020: View {

    @State var subject: Entity?
    @State var collisionBeganUnfiltered: EventSubscription?
    @State var collisionBeganSubject: EventSubscription?
    @State var collisionBeganSubjectColor: EventSubscription?
    @State var collisionEndedSubject: EventSubscription?

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

                // Example 3: Have the red and green spheres change the color of the subject
                // I'm sure there is a better way to do this with filters or masks...
                collisionBeganSubjectColor = content
                    .subscribe(to: CollisionEvents.Began.self, on: subject)  { collisionEvent in
                        print("Collision Subject Color Change \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")
                        if let subject {
                            if(collisionEvent.entityB.name == "StepSphereRed") {
                                swapColorEntity(subject, color: .stepRed)
                            } else if (collisionEvent.entityB.name == "StepSphereGreen") {
                                swapColorEntity(subject, color: .stepGreen)
                            }
                        }
                    }

                // Example 4: Reset the subject after a short timer
                collisionEndedSubject = content
                    .subscribe(to: CollisionEvents.Ended.self, on: subject)  { collisionEvent in
                        print("Collision Subject Revert \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                            if let subject {
                                swapColorEntity(subject, color: .stepBlue)

                            }
                        }
                    }

            }

        }
        .modifier(DragGestureImproved())
    }

    func swapColorEntity(_ entity: Entity, color: UIColor) {
        if var mat = entity.components[ModelComponent.self]?.materials.first as? PhysicallyBasedMaterial {
            mat.baseColor = .init(tint: color)
            entity.components[ModelComponent.self]?.materials[0] = mat
        }
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

}

#Preview {
    Lab020()
}


