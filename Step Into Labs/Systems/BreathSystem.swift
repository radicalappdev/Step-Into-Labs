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

    var accumulatedTime: Float = 0.0  // Accumulate total elapsed time

    func update(context: SceneUpdateContext) {
        for entity in context.entities(
            matching: Self.query,
            updatingSystemWhen: .rendering
        ) {
            if let breath = entity.components[BreathComponent.self] {
                let duration = breath.duration  // Total time for one cycle (up + down)

                // Accumulate delta time across frames
                accumulatedTime += Float(context.deltaTime)

                // Calculate the phase of the sine wave (0 to 2π), wrapping by duration
                let phase = (accumulatedTime / duration) * 2.0 * .pi

                // Compute the scale to smoothly oscillate between 1.0 and 2.0
                let scale = 1.5 + 0.5 * sin(phase)  // Range: [1.0, 2.0]
                print("Breath duration: \(duration), scale: \(scale)")

                // Apply the scale to the entity
                entity.transform.scale = .init(repeating: scale)
            }
        }
    }






}
