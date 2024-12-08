//
//  File.swift
//  RealityKitContent
//
//  Created by Joseph Simpson on 12/8/24.
//

import Foundation
@preconcurrency import RealityKit

public struct EntitySpawnerComponent: Component, Codable {
    public enum SpawnShape: String, Codable {
        case domeUpper
        case domeLower
        case sphere
        case box
        case plane
        case circle
    }
    
    /// The number of clones to create
    public var copies: Int = 12
    /// The shape to spawn entities in
    public var spawnShape: SpawnShape = .domeUpper
    /// Radius for spherical shapes (dome, sphere, circle)
    public var radius: Float = 2.0
    /// Dimensions for box spawning (width, height, depth)
    public var boxDimensions: SIMD3<Float> = SIMD3(2, 2, 2)
    /// Dimensions for plane spawning (width, depth)
    public var planeDimensions: SIMD2<Float> = SIMD2(2, 2)
    /// Track if we've already spawned copies
    public var hasSpawned: Bool = false
    
    public init() {}
}

public class EntitySpawnerSystem: System {
    // Define a query to return all entities with a EntitySpawnerComponent.
    private static let query = EntityQuery(where: .has(EntitySpawnerComponent.self))

    // init is required even when not used
    required public init(scene: Scene) {
        // Perform required initialization or setup.
    }

    private func positionForShape(_ shape: EntitySpawnerComponent.SpawnShape, 
                                component: EntitySpawnerComponent) -> SIMD3<Float> {
        switch shape {
        case .domeUpper:
            let theta = Float.random(in: 0...(2 * .pi))
            let phi = Float.random(in: 0...(Float.pi / 2))
            return SIMD3(
                component.radius * sin(phi) * cos(theta),
                component.radius * cos(phi),
                component.radius * sin(phi) * sin(theta)
            )
            
        case .domeLower:
            let theta = Float.random(in: 0...(2 * .pi))
            let phi = Float.random(in: (Float.pi / 2)...Float.pi)
            return SIMD3(
                component.radius * sin(phi) * cos(theta),
                component.radius * cos(phi),
                component.radius * sin(phi) * sin(theta)
            )
            
        case .sphere:
            let theta = Float.random(in: 0...(2 * .pi))
            let phi = Float.random(in: 0...Float.pi)
            return SIMD3(
                component.radius * sin(phi) * cos(theta),
                component.radius * cos(phi),
                component.radius * sin(phi) * sin(theta)
            )
            
        case .box:
            let dims = component.boxDimensions * 0.5 // Convert to +/- dimensions
            return SIMD3(
                Float.random(in: -dims.x...dims.x),
                Float.random(in: -dims.y...dims.y),
                Float.random(in: -dims.z...dims.z)
            )
            
        case .plane:
            let dims = component.planeDimensions * 0.5 // Convert to +/- dimensions
            return SIMD3(
                Float.random(in: -dims.x...dims.x),
                0,
                Float.random(in: -dims.y...dims.y)
            )
            
        case .circle:
            let angle = Float.random(in: 0...(2 * .pi))
            let randomRadius = Float.random(in: 0...component.radius)
            return SIMD3(
                randomRadius * cos(angle),
                0,
                randomRadius * sin(angle)
            )
        }
    }

    public func update(context: SceneUpdateContext) {
        for entity in context.entities(
            matching: Self.query,
            updatingSystemWhen: .rendering
        ) {
            guard var spawnerComponent = entity.components[EntitySpawnerComponent.self] else { continue }
            if spawnerComponent.hasSpawned { continue }
            
            for _ in 1...spawnerComponent.copies {
                let clone = entity.clone(recursive: true)
                clone.components.remove(EntitySpawnerComponent.self)
                
                // Calculate offset in local space
                let localOffset = positionForShape(spawnerComponent.spawnShape, component: spawnerComponent)
                
                // Convert the local offset to world space using the entity's transform
                let worldTransform = entity.transform
                let rotatedOffset = worldTransform.rotation.act(localOffset)
                clone.position = entity.position + (rotatedOffset * worldTransform.scale)
                
                // Inherit orientation from parent
                clone.orientation = entity.orientation
                

                entity.parent?.addChild(clone)
            }
            
            spawnerComponent.hasSpawned = true
            entity.components[EntitySpawnerComponent.self] = spawnerComponent
        }
    }
}


