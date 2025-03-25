//  Step Into Vision - Labs
//
//  Title: Lab043
//
//  Subtitle: Visualize the Entity Spawner
//
//  Description: Using Components and Systems to create an entity spawner system.
//
//  Type: Space
//
//  Created by Joseph Simpson on 3/25/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab043: View {

    init() {
        EntitySpawnerComponent.registerComponent()
        EntitySpawnerSystem.registerSystem()
    }

    @State var collisionEvent: EventSubscription?

    var body: some View {
        RealityView { content in
            guard let scene = try? await Entity(named: "SpawnerLabResource", in: realityKitContentBundle)  else { return }
            content.add(scene)

            guard let baseTemplate = scene.findEntity(named: "Base"),
                  let shapeVisTemplate = scene.findEntity(named: "ShapeVis"),
                  let domeVis = scene.findEntity(named: "DomeVis"),
                  let subject = scene.findEntity(named: "Subject"),
                  let floor = scene.findEntity(named: "Floor")
            else { return }

            guard let baseMaterial = baseTemplate.components[ModelComponent.self]?.materials.first as? PhysicallyBasedMaterial,
                  let shapeVisMaterial = shapeVisTemplate.components[ModelComponent.self]?.materials.first as? PhysicallyBasedMaterial
            else { return }

            let boxSpawner = createSpawnerSetup(
                position: [-2, 1, 2],
                baseMaterial: baseMaterial,
                shapeVisMaterial: shapeVisMaterial,
                spawnShape: .box,
                visualizationMesh: .generateBox(width: 1.1, height: 1.1, depth: 1.1)
            )
            scene.addChild(boxSpawner)

            let planeSpawner = createSpawnerSetup(
                position: [0, 1, 2],
                baseMaterial: baseMaterial,
                shapeVisMaterial: shapeVisMaterial,
                spawnShape: .plane,
                visualizationMesh: .generatePlane(width: 1.1, depth: 1.1)
            )
            scene.addChild(planeSpawner)

            let circleSpawner = createSpawnerSetup(
                position: [2, 1, 2],
                baseMaterial: baseMaterial,
                shapeVisMaterial: shapeVisMaterial,
                spawnShape: .circle,
                visualizationMesh: .generateCylinder(height: 0.01, radius: 0.55)
            )
            scene.addChild(circleSpawner)

            let sphereSpawner = createSpawnerSetup(
                position: [-2, 1, -2],
                baseMaterial: baseMaterial,
                shapeVisMaterial: shapeVisMaterial,
                spawnShape: .sphere,
                visualizationMesh: .generateSphere(radius: 0.55)
            )
            scene.addChild(sphereSpawner)

            let upperDomeSpawner = createSpawnerSetup(
                position: [0, 1, -2],
                baseMaterial: baseMaterial,
                shapeVisMaterial: shapeVisMaterial,
                spawnShape: .domeUpper,
                visualizationEntity: domeVis.clone(recursive: true)
            )
            scene.addChild(upperDomeSpawner)

            let lowerDomeSpawner = createSpawnerSetup(
                position: [2, 1, -2],
                baseMaterial: baseMaterial,
                shapeVisMaterial: shapeVisMaterial,
                spawnShape: .domeLower,
                visualizationEntity: domeVis.clone(recursive: true),
                rotateVisualization: true
            )
            scene.addChild(lowerDomeSpawner)

            // Disable any spheres that reach the floor
            collisionEvent = content
                .subscribe(to: CollisionEvents.Began.self, on: floor)  { event in
                    event.entityB.isEnabled = false
                    event.entityB.components.set(PhysicsMotionComponent())
                }

            // Disable all template entities after using them
            baseTemplate.isEnabled = false
            shapeVisTemplate.isEnabled = false
            domeVis.isEnabled = false
            subject.isEnabled = false

        }
        .gesture(tap)
        .modifier(DragGestureImproved())
    }

    private func createSpawnerSetup(
        position: SIMD3<Float>,
        baseMaterial: PhysicallyBasedMaterial,
        shapeVisMaterial: PhysicallyBasedMaterial,
        spawnShape: EntitySpawnerComponent.SpawnShape,
        visualizationMesh: MeshResource? = nil,
        visualizationEntity: Entity? = nil,
        rotateVisualization: Bool = false
    ) -> Entity {

        // Create the base platform as a parent entity
        let base = ModelEntity(
            mesh: .generateBox(width: 1.1, height: 0.1, depth: 1.1),
            materials: [baseMaterial]
        )
        base.position = position
        base.collision = CollisionComponent(shapes: [.generateBox(width: 1.1, height: 0.1, depth: 1.1)])
        base.physicsBody = PhysicsBodyComponent(
            massProperties: .init(mass: 1.0),
            material: .default,
            mode: .static
        )
        base.components.set(InputTargetComponent())

        // Create walls for the base
        let wallHeight: Float = 0.1
        let wallThickness: Float = 0.05
        let wallWidth: Float = 1.1

        let wallTemplate = Entity()
        wallTemplate.components.set(ModelComponent(
            mesh: .generateBox(width: wallWidth, height: wallHeight, depth: wallThickness),
            materials: [baseMaterial]
        ))
        wallTemplate.components.set(CollisionComponent(
            shapes: [.generateBox(width: wallWidth, height: wallHeight, depth: wallThickness)]
        ))
        wallTemplate.components.set(PhysicsBodyComponent(
            massProperties: .init(mass: 1.0),
            material: .default,
            mode: .static
        ))

        let frontWall = wallTemplate.clone(recursive: true)
        frontWall.position = [0, wallHeight/2, 0.55 - wallThickness/2]
        base.addChild(frontWall)

        let backWall = wallTemplate.clone(recursive: true)
        backWall.position = [0, wallHeight/2, -0.55 + wallThickness/2]
        base.addChild(backWall)

        let leftWall = wallTemplate.clone(recursive: true)
        leftWall.orientation = simd_quatf(angle: .pi/2, axis: [0, 1, 0])
        leftWall.position = [-0.55 + wallThickness/2, wallHeight/2, 0]
        base.addChild(leftWall)

        let rightWall = wallTemplate.clone(recursive: true)
        rightWall.orientation = simd_quatf(angle: -.pi/2, axis: [0, 1, 0])
        rightWall.position = [0.55 - wallThickness/2, wallHeight/2, 0]
        base.addChild(rightWall)

        // Create spawn volume visualization
        let shapeVis: Entity
        if let visualizationEntity = visualizationEntity {
            shapeVis = visualizationEntity
            if rotateVisualization {
                // Rotate 180 degrees for lower dome
                shapeVis.orientation = simd_quatf(angle: .pi, axis: [1, 0, 0])
            }
        } else {
            shapeVis = ModelEntity(
                mesh: visualizationMesh!,
                materials: [shapeVisMaterial]
            )
        }
        shapeVis.position = [0, 1, 0]
        shapeVis.components.remove(InputTargetComponent.self)
        base.addChild(shapeVis)

        // Create and setup spawner
        let spawner = Entity()
        spawner.position = [0, 1, 0]
        var spawnerComponent = EntitySpawnerComponent()
        spawnerComponent.SpawnShape = spawnShape

        // Set appropriate dimensions based on spawn shape
        switch spawnShape {
        case .plane:
            spawnerComponent.PlaneDimensions = [1, 1]
        case .circle:
            spawnerComponent.Radius = 0.5
        case .box:
            spawnerComponent.BoxDimensions = [1, 1, 1]
        case .sphere, .domeUpper, .domeLower:
            spawnerComponent.Radius = 0.5
        }

        spawnerComponent.Copies = 10
        spawnerComponent.TargetEntityName = "Subject"
        spawner.components[EntitySpawnerComponent.self] = spawnerComponent
        base.addChild(spawner)

        return base
    }

    var tap: some Gesture {
        TapGesture()
            .targetedToEntity(where: .has(PhysicsMotionComponent.self))
            .onEnded { value in
                value.entity.isEnabled = false
            }
    }

}

#Preview {
    Lab043()
}
