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

    var accumulatedTime: [Entity: Float] = [:] // Track accumulated time per entity

    func update(context: SceneUpdateContext) {
        for entity in context.entities(
            matching: Self.query,
            updatingSystemWhen: .rendering
        ) {
            guard let breath = entity.components[BreathComponent.self] else { continue }

            let duration = breath.duration
            let deltaTime = Float(context.deltaTime)

            // Accumulate time for this entity
            accumulatedTime[entity, default: 0.0] += deltaTime

            // Calculate the phase of the sine wave (0 to 2π), wrapping by duration
            let phase = (accumulatedTime[entity]! / duration) * 2.0 * .pi

            // Compute the scale to smoothly oscillate between 1.0 and 2.0
            let scale = 1.5 + 0.5 * sin(phase)

            // Apply the scale to the entity
            entity.transform.scale = .init(repeating: scale)

            // Reset accumulated time if a full cycle has passed
            if accumulatedTime[entity]! >= duration {
                accumulatedTime[entity] = 0.0
            }
        }
    }






}
