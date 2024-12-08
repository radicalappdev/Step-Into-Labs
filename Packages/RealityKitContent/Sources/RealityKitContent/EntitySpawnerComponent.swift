//
//  File.swift
//  RealityKitContent
//
//  Created by Joseph Simpson on 12/8/24.
//

import Foundation
@preconcurrency import RealityKit

public struct EntitySpawnerComponent: Component, Codable {

    /// The number of clones to create
    public var copies: Int = 12

/// Track if we've already spawned copies
    public var hasSpawned: Bool = false
    

    public init() {

    }
}


public class EntitySpawnerSystem: System {

    // Define a query to return all entities with a EntitySpawnerComponent.
    private static let query = EntityQuery(where: .has(EntitySpawnerComponent.self))

    // init is required even when not used
    required public init(scene: Scene) {
        // Perform required initialization or setup.
    }

        public func update(context: SceneUpdateContext) {
        for entity in context.entities(
            matching: Self.query,
            updatingSystemWhen: .rendering
        ) {
            // Get the component
            guard var spawnerComponent = entity.components[EntitySpawnerComponent.self] else { continue }
            
            // Skip if we've already spawned
            if spawnerComponent.hasSpawned { continue }
            
            // Create the clones
            let centerPos = entity.position
            for _ in 1...spawnerComponent.copies {
                let clone = entity.clone(recursive: true)
                clone.components.remove(EntitySpawnerComponent.self)
                
                // Random spherical coordinates
                let distance = Float.random(in: 1...3)
                let theta = Float.random(in: 0...(2 * .pi))
                // Only use upper hemisphere (0 to π/2)
                let phi = Float.random(in: 0...(Float.pi / 2))
                
                // Convert spherical coordinates to Cartesian (unchanged formula)
                let x = distance * sin(phi) * cos(theta)
                let y = distance * cos(phi)  // This gives us the height
                let z = distance * sin(phi) * sin(theta)
                clone.position = centerPos + SIMD3(x, y, z)
                
                entity.parent?.addChild(clone)
            }
            
            // Mark as spawned
            spawnerComponent.hasSpawned = true
            entity.components[EntitySpawnerComponent.self] = spawnerComponent
        }
    }

}


