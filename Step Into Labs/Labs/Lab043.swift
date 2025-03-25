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
            mesh: .generateBox(width: 1, height: 0.1, depth: 1),
            materials: [baseMaterial]
        )
        base.position = position
        base.collision = CollisionComponent(shapes: [.generateBox(width: 1, height: 0.1, depth: 1)])
        base.physicsBody = PhysicsBodyComponent(
            massProperties: .init(mass: 1.0),
            material: .default,
            mode: .static
        )
        base.components.set(InputTargetComponent())

        // Create spawn volume visualization as child of base
        let shapeVis = ModelEntity(
            mesh: .generateBox(width: 1.1, height: 1.1, depth: 1.1),
            materials: [shapeVisMaterial]
        )
        shapeVis.position = [0, 1, 0]  // 1m above base
        base.addChild(shapeVis)

        // Create and setup spawner as child of base
        let spawner = Entity()
        spawner.position = [0, 1, 0]  // Same height as visualization
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
