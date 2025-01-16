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

    @State var enableGravity = false

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

            // Create a dictionary to store our entities
            var entityDict: [String: Entity] = [:]

            // Refactored entity setup using loop
            for component in blocks {
                if let entity = attachments.entity(for: component.id) {
                    window.addChild(entity)
                    entity.setPosition(component.position, relativeTo: window)
                    
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
                    
                    // Add InputTargetComponent only to WindowHandle
                    if component.id == "WindowHandle" {
                        entity.components.set(InputTargetComponent())
                    }
                    
                    // Store entity in dictionary
                    entityDict[component.id] = entity
                }
            }

            // Create joints after all entities are created
            if let handle = entityDict["WindowHandle"],
               let background = entityDict["WindowBackground"],
               let list = entityDict["WindowList"] {
                
                // Join Background to Handle
                let handleJoint = createFixedJoint(
                    between: handle,
                    and: background,
                    name: "handle_background"
                )
                
                // Join Title, Button, and List to Background
                for childId in ["WindowTitle", "WindowButton", "WindowList"] {
                    if let child = entityDict[childId] {
                        let childJoint = createFixedJoint(
                            between: background,
                            and: child,
                            name: "background_\(childId)"
                        )
                        Task {
                            try await childJoint.addToSimulation()
                        }
                    }
                }
                
                // Join Rows to List
                for rowId in ["WindowRow1", "WindowRow2", "WindowRow3"] {
                    if let row = entityDict[rowId] {
                        let rowJoint = createFixedJoint(
                            between: list,
                            and: row,
                            name: "list_\(rowId)"
                        )
                        Task {
                            try await rowJoint.addToSimulation()
                        }
                    }
                }
                
                // Add handle joint last
                Task {
                    try await handleJoint.addToSimulation()
                }
            }
        } update: { content, attachments in

            if enableGravity {

            }

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
                    enableGravity = true
                }, label: {
                    Image(systemName: "plus")
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
    }

    // Helper function to create fixed joints
    func createFixedJoint(between entity1: Entity, and entity2: Entity, name: String) -> PhysicsFixedJoint {
        let pin1 = entity1.pins.set(
            named: "\(name)_pin1",
            position: .zero,
            orientation: .init(angle: .pi, axis: [0, 0, 1])
        )
        
        let pin2 = entity2.pins.set(
            named: "\(name)_pin2",
            position: entity2.position(relativeTo: entity1),
            orientation: .init(angle: .pi, axis: [0, 0, 1])
        )
        
        return PhysicsFixedJoint(pin0: pin1, pin1: pin2)
    }
}

#Preview {
    Lab025()
}
