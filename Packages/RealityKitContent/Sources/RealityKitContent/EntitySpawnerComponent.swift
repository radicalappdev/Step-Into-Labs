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
        case cube
        case plane
        case circle
    }
    
    /// The number of clones to create
    public var copies: Int = 12
    /// The shape to spawn entities in
    public var spawnShape: SpawnShape = .domeUpper
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

    private func positionForShape(_ shape: EntitySpawnerComponent.SpawnShape, distance: Float) -> SIMD3<Float> {
        switch shape {
        case .domeUpper:
            let theta = Float.random(in: 0...(2 * .pi))
            let phi = Float.random(in: 0...(Float.pi / 2))
            return SIMD3(
                distance * sin(phi) * cos(theta),
                distance * cos(phi),
                distance * sin(phi) * sin(theta)
            )
            
        case .domeLower:
            let theta = Float.random(in: 0...(2 * .pi))
            let phi = Float.random(in: (Float.pi / 2)...Float.pi)
            return SIMD3(
                distance * sin(phi) * cos(theta),
                distance * cos(phi),
                distance * sin(phi) * sin(theta)
            )
            
        case .sphere:
            let theta = Float.random(in: 0...(2 * .pi))
            let phi = Float.random(in: 0...Float.pi)
            return SIMD3(
                distance * sin(phi) * cos(theta),
                distance * cos(phi),
                distance * sin(phi) * sin(theta)
            )
            
        case .cube:
            return SIMD3(
                Float.random(in: -distance...distance),
                Float.random(in: -distance...distance),
                Float.random(in: -distance...distance)
            )
            
        case .plane:
            return SIMD3(
                Float.random(in: -distance...distance),
                0,
                Float.random(in: -distance...distance)
            )
            
        case .circle:
            let angle = Float.random(in: 0...(2 * .pi))
            let radius = Float.random(in: 0...distance)
            return SIMD3(
                radius * cos(angle),
                0,
                radius * sin(angle)
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
            
            let centerPos = entity.position
            for _ in 1...spawnerComponent.copies {
                let clone = entity.clone(recursive: true)
                clone.components.remove(EntitySpawnerComponent.self)
                
                let offset = positionForShape(spawnerComponent.spawnShape, distance: Float.random(in: 1...3))
                clone.position = centerPos + offset
                
                entity.parent?.addChild(clone)
            }
            
            spawnerComponent.hasSpawned = true
            entity.components[EntitySpawnerComponent.self] = spawnerComponent
        }
    }
}


