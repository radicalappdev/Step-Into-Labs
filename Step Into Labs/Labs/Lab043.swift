//  Step Into Vision - Labs
//
//  Title: Lab043
//
//  Subtitle:
//
//  Description:
//
//  Type:
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

    var body: some View {
        RealityView { content, attachments in
            guard let scene = try? await Entity(named: "SpawnerLabResource", in: realityKitContentBundle)  else { return }
            content.add(scene)

            guard let baseMaterial = scene.findEntity(named: "Base")?.components[ModelComponent.self]?.materials.first,
                  let shapeVisMaterial = scene.findEntity(named: "ShapeVis")?.components[ModelComponent.self]?.materials.first 
            else { return }

            let spawnerSetup = createSpawnerSetup(
                position: [0, 1.5, -2],
                baseMaterial: baseMaterial as! PhysicallyBasedMaterial,
                shapeVisMaterial: shapeVisMaterial as! PhysicallyBasedMaterial
            )
            scene.addChild(spawnerSetup)

        } update: { content, attachments in
        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("wow")
            }
        }
        .gesture(tap)
        .modifier(DragGestureImproved())
    }

    private func createSpawnerSetup(
        position: SIMD3<Float>,
        baseMaterial: PhysicallyBasedMaterial,
        shapeVisMaterial: PhysicallyBasedMaterial
    ) -> Entity {
        // Create the base platform - this will be our parent entity
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

        // Add walls to the base
        let wallHeight: Float = 0.1
        let wallThickness: Float = 0.05
        
        // Front wall
        let frontWall = Entity()
        frontWall.components.set(ModelComponent(
            mesh: .generateBox(width: 1.1, height: wallHeight, depth: wallThickness),
            materials: [baseMaterial]
        ))
        frontWall.components.set(CollisionComponent(shapes: [.generateBox(width: 1.1, height: wallHeight, depth: wallThickness)]))
        frontWall.components.set(PhysicsBodyComponent(massProperties: .init(mass: 1.0), material: .default, mode: .static))
        frontWall.position = [0, wallHeight/2, 0.55 - wallThickness/2]
        base.addChild(frontWall)
        
        // Back wall
        let backWall = Entity()
        backWall.components.set(ModelComponent(
            mesh: .generateBox(width: 1.1, height: wallHeight, depth: wallThickness),
            materials: [baseMaterial]
        ))
        backWall.components.set(CollisionComponent(shapes: [.generateBox(width: 1.1, height: wallHeight, depth: wallThickness)]))
        backWall.components.set(PhysicsBodyComponent(massProperties: .init(mass: 1.0), material: .default, mode: .static))
        backWall.position = [0, wallHeight/2, -0.55 + wallThickness/2]
        base.addChild(backWall)
        
        // Left wall
        let leftWall = Entity()
        leftWall.components.set(ModelComponent(
            mesh: .generateBox(width: wallThickness, height: wallHeight, depth: 1.1),
            materials: [baseMaterial]
        ))
        leftWall.components.set(CollisionComponent(shapes: [.generateBox(width: wallThickness, height: wallHeight, depth: 1.1)]))
        leftWall.components.set(PhysicsBodyComponent(massProperties: .init(mass: 1.0), material: .default, mode: .static))
        leftWall.position = [-0.55 + wallThickness/2, wallHeight/2, 0]
        base.addChild(leftWall)
        
        // Right wall
        let rightWall = Entity()
        rightWall.components.set(ModelComponent(
            mesh: .generateBox(width: wallThickness, height: wallHeight, depth: 1.1),
            materials: [baseMaterial]
        ))
        rightWall.components.set(CollisionComponent(shapes: [.generateBox(width: wallThickness, height: wallHeight, depth: 1.1)]))
        rightWall.components.set(PhysicsBodyComponent(massProperties: .init(mass: 1.0), material: .default, mode: .static))
        rightWall.position = [0.55 - wallThickness/2, wallHeight/2, 0]
        base.addChild(rightWall)

        // Create spawn volume visualization as child of base
        let shapeVis = ModelEntity(
            mesh: .generateBox(width: 1.1, height: 1.1, depth: 1.1),
            materials: [shapeVisMaterial]
        )
        shapeVis.position = [0, 1, 0]
        base.addChild(shapeVis)

        // Create and setup spawner as child of base
        let spawner = Entity()
        spawner.position = [0, 1, 0]
        var spawnerComponent = EntitySpawnerComponent()
        spawnerComponent.SpawnShape = .box
        spawnerComponent.BoxDimensions = [1, 1, 1]
        spawnerComponent.Copies = 10
        spawnerComponent.TargetEntityName = "Subject"
        spawner.components[EntitySpawnerComponent.self] = spawnerComponent
        base.addChild(spawner)

        return base
    }

    var tap: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                value.entity.isEnabled = false
            }
    }

}
#Preview {
    Lab043()
}
