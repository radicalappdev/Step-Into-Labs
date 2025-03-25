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
            if let scene = try? await Entity(named: "SpawnerLabResource", in: realityKitContentBundle) {
                content.add(scene)

                // Get the materials from the provided entities
                if let baseMaterial = scene.findEntity(named: "Base")?.components[ModelComponent.self]?.materials.first,
                   let shapeVisMaterial = scene.findEntity(named: "ShapeVis")?.components[ModelComponent.self]?.materials.first {
                    
                    // Create the base platform
                    let base = ModelEntity(
                        mesh: .generateBox(width: 1, height: 0.1, depth: 1),
                        materials: [baseMaterial]
                    )
                    base.position = [0, 1.5, -2]
                    base.collision = CollisionComponent(shapes: [.generateBox(width: 1, height: 0.1, depth: 1)])
                    base.physicsBody = PhysicsBodyComponent(
                        massProperties: .init(mass: 1.0),
                        material: .default,
                        mode: .static
                    )
                    scene.addChild(base)
                    
                    // Create spawn volume visualization (slightly larger than 1m spawn volume)
                    let shapeVis = ModelEntity(
                        mesh: .generateBox(width: 1.1, height: 1.1, depth: 1.1),
                        materials: [shapeVisMaterial]
                    )
                    shapeVis.position = [0, 2.5, -2]
                    scene.addChild(shapeVis)
                    
                    // Create and setup spawner
                    let spawner = Entity()
                    spawner.position = [0, 2.5, -2]
                    var spawnerComponent = EntitySpawnerComponent()
                    spawnerComponent.SpawnShape = .box
                    spawnerComponent.BoxDimensions = [1, 1, 1]  // 1m cube spawn volume
                    spawnerComponent.Copies = 10
                    spawnerComponent.TargetEntityName = "Subject"
                    spawner.components[EntitySpawnerComponent.self] = spawnerComponent
                    scene.addChild(spawner)
                }
            }
        } update: { content, attachments in
        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("wow")
            }
        }
        .gesture(tap)
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
