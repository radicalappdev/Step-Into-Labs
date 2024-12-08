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
    
    // These prooerties get their default values in RCP
    /// The number of clones to create
    public var Copies: Int = 12
    /// The shape to spawn entities in
    public var SpawnShape: SpawnShape = .domeUpper
    /// Radius for spherical shapes (dome, sphere, circle)
    public var Radius: Float = 5.0
   
    // These properties DO NOT get their default values in RCP. The all show 0
    /// Dimensions for box spawning (width, height, depth)
    public var BoxDimensions: SIMD3<Float> = SIMD3(2.0, 2.0, 2.0)
   
    /// Dimensions for plane spawning (width, depth)
    public var PlaneDimensions: SIMD2<Float> = SIMD2(2.0, 2.0)
   
    /// Track if we've already spawned copies
    public var HasSpawned: Bool = false
    
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

    private func positionForShape(_ shape: EntitySpawnerComponent.SpawnShape, 
                                component: EntitySpawnerComponent) -> SIMD3<Float> {
    switch shape {
  case .domeUpper:
        let distance = Float.random(in: 1...component.Radius)
        let theta = Float.random(in: 0...(2 * .pi))
        let phi = Float.random(in: 0...(Float.pi / 2))
        return SIMD3(
            distance * sin(phi) * cos(theta),
            distance * cos(phi),
            distance * sin(phi) * sin(theta)
        )
        
    case .domeLower:
        let distance = Float.random(in: 1...component.Radius)
        let theta = Float.random(in: 0...(2 * .pi))
        let phi = Float.random(in: (Float.pi / 2)...Float.pi)
        return SIMD3(
            distance * sin(phi) * cos(theta),
            distance * cos(phi),
            distance * sin(phi) * sin(theta)
        )
            
        case .sphere:
            let distance = Float.random(in: 1...component.Radius)
            let theta = Float.random(in: 0...(2 * .pi))
            let phi = Float.random(in: 0...Float.pi)
            return SIMD3(
                distance * sin(phi) * cos(theta),
                distance * cos(phi),
                distance * sin(phi) * sin(theta)
            )
            
        case .box:
            let dims = component.BoxDimensions * 0.5 // Convert to +/- dimensions
            return SIMD3(
                Float.random(in: -dims.x...dims.x),
                Float.random(in: -dims.y...dims.y),
                Float.random(in: -dims.z...dims.z)
            )
            
        case .plane:
            let dims = component.PlaneDimensions * 0.5 // Convert to +/- dimensions
            return SIMD3(
                Float.random(in: -dims.x...dims.x),
                0,
                Float.random(in: -dims.y...dims.y)
            )
            
        case .circle:
            let angle = Float.random(in: 0...(2 * .pi))
            let randomRadius = Float.random(in: 0...component.Radius)
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
            if spawnerComponent.HasSpawned { continue }
            
            for _ in 1...spawnerComponent.Copies {
                let clone = entity.clone(recursive: true)
                clone.components.remove(EntitySpawnerComponent.self)
                
                // Calculate offset in local space
                let localOffset = positionForShape(spawnerComponent.SpawnShape, component: spawnerComponent)
                
                // Convert the local offset to world space using the entity's transform
                let worldTransform = entity.transform
                let rotatedOffset = worldTransform.rotation.act(localOffset)
                clone.position = entity.position + (rotatedOffset * worldTransform.scale)
                
                // Inherit orientation from parent
                clone.orientation = entity.orientation
                

                entity.parent?.addChild(clone)
            }
            
            spawnerComponent.HasSpawned = true
            entity.components[EntitySpawnerComponent.self] = spawnerComponent
        }
    }
}


