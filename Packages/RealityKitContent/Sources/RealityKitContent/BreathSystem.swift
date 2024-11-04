//
//  File.swift
//  RealityKitContent
//
//  Created by Joseph Simpson on 10/24/24.
//

import Foundation
@preconcurrency import RealityKit

// Added to teach myself ECS in visionOS starting with Lab 010
public struct BreathComponent: Component, Codable {

    public var accumulatedTime: Float = 0
    public var duration: Float = 4.0

    public init() {

    }
}


// This was used by Lab 010 to learn my way around components and systems
public class BreathSystem: System {

    // Define a query to return all entities with a BreathComponent.
    private static let query = EntityQuery(where: .has(BreathComponent.self))

    // init is required even when not used
    required public init(scene: Scene) {
        // Perform required initialization or setup.
    }

    // Track accumulated time per entity - this will break if we have a dymaic number of entities
    var accumulatedTime: [Entity: Float] = [:]

    public func update(context: SceneUpdateContext) {
        for entity in context.entities(
            matching: Self.query,
            updatingSystemWhen: .rendering
        ) {

            // Get the component
            var breath = entity.components[BreathComponent.self]!
            let duration = breath.duration

            // Accumulate time for this entity and set the new value on the component
            breath.accumulatedTime += Float(context.deltaTime)

            // Calculate the phase of the sine wave (0 to 2π), wrapping by duration
            let phase = (breath.accumulatedTime / duration) * 2.0 * .pi

            // Compute the scale to smoothly oscillate between 1.0 and 2.0
            let scale = 1.5 + 0.5 * sin(phase)

            // Apply the scale to the entity
            entity.transform.scale = .init(repeating: scale)

            // Reset accumulated time if a full cycle has passed
            if breath.accumulatedTime >= duration {
                breath.accumulatedTime = 0.0
            }

            entity.components[BreathComponent.self] = breath



        }
    }

}
