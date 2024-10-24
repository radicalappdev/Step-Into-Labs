//
//  BreathSystem.swift
//  Step Into Labs
//
//  Created by Joseph Simpson on 10/24/24.
//  https://developer.apple.com/documentation/RealityKit/implementing-systems-for-entities-in-a-scene

import Foundation
import RealityKit
import RealityKitContent

class BreathSystem: System {

    // Define a query to return all entities with a BreathComponent.
    private static let query = EntityQuery(where: .has(BreathComponent.self))


    required init(scene: Scene) {
        // Perform required initialization or setup.
    }

    var accumulatedTime: Float = 0.0  // Store the accumulated time

    func update(context: SceneUpdateContext) {
        for entity in context.entities(
            matching: Self.query,
            updatingSystemWhen: .rendering
        ) {
            if let breath = entity.components[BreathComponent.self] {
                let duration = breath.duration  // Duration for one full breathing cycle

                // Accumulate delta time to track the total animation progress
                accumulatedTime += Float(context.deltaTime)

                // Normalize accumulated time within the duration (wrap around after a full cycle)
                let normalizedTime = accumulatedTime.truncatingRemainder(dividingBy: duration)

                // Map normalized time to a phase (radians) for smooth sin wave scaling
                let phase = (normalizedTime / duration) * 2.0 * .pi

                // Scale oscillates between 1.0 and 2.0
                let scale = 1.0 + 0.5 * (1.0 + sin(phase))
                // print("Breath duration: \(duration), scale: \(scale)")

                // Apply the scale uniformly to the entity
                entity.transform.scale = .init(repeating: scale)
            }
        }
    }



}
