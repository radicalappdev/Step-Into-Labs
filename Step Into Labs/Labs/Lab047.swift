//  Step Into Vision - Labs
//
//  Title: Lab047
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 4/29/25.

import SwiftUI
import RealityKit
import RealityKitContent
import ARKit

struct Lab047: View {

    @State var session = ARKitSession()

    @State var planeAnchorsSimple: [UUID: Entity] = [:]

    var body: some View {
        
        let flowers: [String] = ["🌼", "🌹", "🌷", "🌻", "🌸", "🪻", "🥀", "🪸", "🌾", "💐"]

        RealityView { content, attachments in

            for flower in flowers {
                if let flower = attachments.entity(for: flower)  {

                    let parent = Entity()

                    // Calculate a random position
                    let x: Float = Float.random(in: -1...1)
                    let y: Float = Float.random(in: 0...2)
                    let z: Float = Float.random(in: -1...1)
                    parent.position = SIMD3<Float>(x, y, z)

                    let collision = CollisionComponent(shapes: [.generateSphere(radius: 0.1)])

                    var physics = PhysicsBodyComponent(
                        shapes: [.generateSphere(radius: 0.1)],
                        mass: 1.0,
                        material: .generate(friction: 0, restitution: 1),
                        mode: .dynamic
                    )
                    physics.isAffectedByGravity = false

                    let input = InputTargetComponent()
                    parent.components.set([collision, physics, input])
                    let billboard = BillboardComponent()
                    flower.components.set([billboard])

                    parent.addChild(flower)


                    content.add(parent)


                }

            }


        } update: { content, attachments in
            for (_, entity) in planeAnchorsSimple {
                if !content.entities.contains(entity) {
                    content.add(entity)
                }
            }
        } attachments: {
            ForEach(flowers, id: \.self) { flower in
                Attachment(id: flower) {
                    Text(flower)
                        .font(.system(size: 144))
                }
            }
        }
        .gesture(TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                // Add some force when we tap on any of the flowers
                let force = SIMD3<Float>(
                    x: Float.random(in: -1...1),
                    y: Float.random(in: -1...1),
                    z: Float.random(in: -1...1)
                )
                var motion = PhysicsMotionComponent()
                motion.linearVelocity = force * 3
                value.entity.components.set(motion)
            })
        .task {
            try! await setupAndRunPlaneDetection()
        }
    }

    func setupAndRunPlaneDetection() async throws {
        let planeData = PlaneDetectionProvider(alignments: [.horizontal, .vertical, ])
        if PlaneDetectionProvider.isSupported {
            do {
                try await session.run([planeData])
                for await update in planeData.anchorUpdates {
                    switch update.event {
                    case .added, .updated:
                        let anchor = update.anchor

                        let planeEntitySimple = createSimplePlaneEntity(for: anchor)
                        planeAnchorsSimple[anchor.id] = planeEntitySimple

                    case .removed:
                        let anchor = update.anchor
                        planeAnchorsSimple.removeValue(forKey: anchor.id)

                    }
                }
            } catch {
                print("ARKit session error \(error)")
            }
        }
    }

    func createSimplePlaneEntity(for anchor: PlaneAnchor) -> Entity {

        let extent = anchor.geometry.extent
        let mesh = MeshResource.generatePlane(width: extent.width, height: extent.height)
        let material = OcclusionMaterial()

        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.transform = Transform(matrix: matrix_multiply(anchor.originFromAnchorTransform, extent.anchorFromExtentTransform))

        // We'll let RealityKit generate a simple collision shape based on the entity.
        // For more detailed shapes see: https://stepinto.vision/example-code/arkit-planedetectionprovider-adding-collisions-and-physics/
        entity.generateCollisionShapes(recursive: true, static: true)
        let physicsMaterial = PhysicsMaterialResource.generate(friction: 0, restitution: 1)
        let physics = PhysicsBodyComponent(massProperties: .default, material: physicsMaterial, mode: .static)
        entity.components.set(physics)

        return entity
    }
}

#Preview {
    Lab047()
}
