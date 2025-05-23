//  Step Into Vision - Labs
//
//  Title: Lab047
//
//  Subtitle: Emoji Friends
//
//  Description: Making some little emoji spheres to bounce around my office.
//
//  Type: Space
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

        let emoji = ["😀", "😃", "😄", "😁", "😆", "☺️", "😊", "🙃", "😌", "😛", "😝", "😜", "🤪", "🤓", "😎", "🙂‍↔️"]

        RealityView { content, attachments in

            for em in emoji {
                if let em = attachments.entity(for: em)  {

                    let parent = Entity()
                    // Just a hack to have an inside-out sphere
                    
                    let model = ModelEntity(
                        mesh: .generateSphere(radius: 0.1),
                        materials: [SimpleMaterial(color: .black, isMetallic: false)])
                    model.scale = SIMD3(x: -1, y: 1, z: 1) // flip this inside out
                    parent.addChild(model)

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

                    em.components.set([BillboardComponent(), HoverEffectComponent()])

                    parent.addChild(em)
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
            ForEach(emoji, id: \.self) { em in
                Attachment(id: em) {
                    Text(em)
                        .font(.system(size: 144))
                }
            }
        }
        .gesture(TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                applyMotion(entity: value.entity)
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
        entity.generateCollisionShapes(recursive: true, static: true)

        let physicsMaterial = PhysicsMaterialResource.generate(friction: 0, restitution: 1)
        let physics = PhysicsBodyComponent(massProperties: .default, material: physicsMaterial, mode: .static)
        entity.components.set(physics)

        return entity
    }

    func applyMotion(entity: Entity) {

        // Add some force when we tap on any of the flowers
        let force = SIMD3<Float>(
            x: Float.random(in: -1...1),
            y: Float.random(in: -1...1),
            z: Float.random(in: -1...1)
        )
        var motion = PhysicsMotionComponent()
        motion.linearVelocity = force * 4
        entity.components.set(motion)

    }
}

#Preview {
    Lab047()
}
