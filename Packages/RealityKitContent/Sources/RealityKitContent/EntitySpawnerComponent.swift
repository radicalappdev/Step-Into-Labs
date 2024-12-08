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

            let copies = spawnerComponent.copies




        }
    }

}

// This is a copy of a function from another project. This logic needs to be incorporated into the system
func createClones(_ root: Entity, glassSphere: Entity) {
    let centerPos = SIMD3<Float>(0, 1.5, 0)
    for _ in 1...100 {
        let clone = glassSphere.clone(recursive: true)
        // Random spherical coordinates - thanks ChatGPT!
        let distance = Float.random(in: 1...3) // Radius between 1 and 3
        let theta = Float.random(in: 0...(2 * .pi)) // Random angle for the horizontal plane
        let phi = Float.random(in: 0...(Float.pi)) // Random angle for the vertical plane

        // Convert spherical coordinates to Cartesian
        let x = distance * sin(phi) * cos(theta)
        let y = distance * sin(phi) * sin(theta)
        let z = distance * cos(phi)
        clone.position = centerPos + SIMD3(x, y, z)
        root.addChild(clone)
    }
}
