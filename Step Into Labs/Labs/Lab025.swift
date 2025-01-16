//  Step Into Vision - Labs
//
//  Title: Lab025
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 1/16/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab025: View {

    // Define a structure for blocks
    struct BlockData {
        let id: String
        let position: SIMD3<Float>
        let collisionSize: (width: Float, height: Float, depth: Float)
    }

    let blocks: [BlockData] = [
        BlockData(id: "WindowHandle", position: [0, -0.13, 0], collisionSize: (0.3, 0.21, 0.001)),
        BlockData(id: "WindowBackground", position: [0, 0, 0], collisionSize: (0.3, 0.21, 0.001)),
        BlockData(id: "WindowTitle", position: [-0.102, 0.08, 0], collisionSize: (0.05, 0.03, 0.001)),
        BlockData(id: "WindowButton", position: [0.102, 0.08, 0], collisionSize: (0.05, 0.03, 0.001)),
        BlockData(id: "WindowList", position: [0, -0.02, 0], collisionSize: (0.26, 0.12, 0.001)),
        BlockData(id: "WindowRow1", position: [0, 0.024, 0.0001], collisionSize: (0.26, 0.04, 0.001)),
        BlockData(id: "WindowRow2", position: [0, -0.0189, 0.0001], collisionSize: (0.26, 0.04, 0.001)),
        BlockData(id: "WindowRow3", position: [0, -0.064, 0.0001], collisionSize: (0.26, 0.04, 0.001))
    ]

    // Add state to store the window entity
    @State private var windowEntity: Entity?

    var body: some View {
        RealityView { content, attachments in

            let floor = Entity()
            floor.setPosition([0, 0, 0], relativeTo: nil)
            let floorCollision = CollisionComponent(shapes: [ShapeResource.generateBox(width: 10, height: 0.01, depth: 10)])
            floor.components.set(floorCollision)

            var floorPhysics = PhysicsBodyComponent()
            floorPhysics.mode = .static
            floorPhysics.isAffectedByGravity = false
            floor.components.set(floorPhysics)
            content.add(floor)

            let window = Entity()
            window.setPosition([1, 1.5, -2], relativeTo: nil)
            window.setScale([3, 3, 3], relativeTo: nil)
            window.components.set(PhysicsSimulationComponent())
            window.components.set(PhysicsJointsComponent())
            content.add(window)
            
            // Store window entity in state
            windowEntity = window

            var entityDict: [String: Entity] = [:]

            for component in blocks {
                if let entity = attachments.entity(for: component.id) {
                    window.addChild(entity)
                    entity.setPosition(component.position, relativeTo: window)
                    entity.name = component.id

                    let collision = CollisionComponent(shapes: [
                        ShapeResource.generateBox(
                            width: component.collisionSize.width,
                            height: component.collisionSize.height,
                            depth: component.collisionSize.depth
                        )
                    ])
                    entity.components.set(collision)
                    
                    var physicsBody = PhysicsBodyComponent()
                    physicsBody.isAffectedByGravity = false
                    physicsBody.mode = .dynamic  // Make all bodies dynamic
                    entity.components.set(physicsBody)
                    
                    entity.components.set(InputTargetComponent())

                    entityDict[component.id] = entity
                }
            }


        } update: { content, attachments in
            // Add update closure for handling reset
        } attachments: {

            Attachment(id: "WindowHandle") {
                Capsule()
                    .foregroundStyle(.white.opacity(0.4))
                    .frame(width: 100, height: 8)
            }

            Attachment(id: "WindowBackground") {
                VStack {
                    EmptyView()
                }
                .frame(width: 400, height: 300)
                .glassBackgroundEffect()
            }

            Attachment(id: "WindowTitle") {
                Text("Fruits")
                    .font(.title)
                    .frame(height: 60)
            }

            Attachment(id: "WindowButton") {
                Button(action: {
                    print("button pressed")
                }, label: {
                    Image(systemName: "arrow.clockwise")
                })
                .glassBackgroundEffect()
            }

            Attachment(id: "WindowList") {
                List {
                    Text("")
                    Text("")
                    Text("")
                }
                .frame(width: 400, height: 180)
            }

            Attachment(id: "WindowRow1") {
                HStack{
                    Text("Apple")
                    Spacer()
                }
                .padding()
                .frame(width: 350, height: 60)
                .background(.thickMaterial)
                .clipShape(
                    .rect(
                        topLeadingRadius: 18,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 18
                    )
                )
            }

            Attachment(id: "WindowRow2") {
                HStack{
                    Text("Banana")
                    Spacer()
                }
                .padding()
                .frame(width: 350, height: 60)
                .background(.thickMaterial)

            }

            Attachment(id: "WindowRow3") {
                HStack{
                    Text("Orange")
                    Spacer()
                }
                .padding()
                .frame(width: 350, height: 60)
                .background(.thickMaterial)
                .clipShape(
                    .rect(
                        topLeadingRadius: 0,
                        bottomLeadingRadius:18,
                        bottomTrailingRadius:18,
                        topTrailingRadius: 0
                    )
                )
            }

        }
        .modifier(DragGestureImproved())
        .gesture(tapExample)

    }

    var tapExample: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                if value.entity.name == "WindowButton" {
                    resetEntities()
                }
            }
    }

    // Add reset function
    private func resetEntities() {
        print("reset pressed")
        guard let window = windowEntity else { return }
        
        // Animate window position and rotation
        window.move(
            to: Transform(
                scale: .init(repeating: 3),
                rotation: .init(angle: 0, axis: [0, 1, 0]),
                translation: [1, 1.5, -2]
            ),
            relativeTo: nil,
            duration: 0.5,
            timingFunction: .easeInOut
        )
        
        // Reset all child entities relative positions
        for block in blocks {
            if let entity = window.findEntity(named: block.id) {
                // Animate each entity back to its original position
                entity.move(
                    to: Transform(
                        scale: .one,
                        rotation: .init(angle: 0, axis: [0, 1, 0]),
                        translation: block.position
                    ),
                    relativeTo: window,
                    duration: 0.5,
                    timingFunction: .easeInOut
                )
                
                // Reset physics motion
                var motion = PhysicsMotionComponent()
                motion.linearVelocity = .zero
                motion.angularVelocity = .zero
                entity.components.set(motion)
            }
        }
    }
}

#Preview {
    Lab025()
}
