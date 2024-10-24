//  Step Into Vision - Labs
//
//  Title: Lab008
//
//  Subtitle: Anchor an Entity to the head
//
//  Description: Create an entity and anchor it to a point in front of the user as they move their head.
//
//  Type: Space
//
//  Created by Joseph Simpson on 10/24/24.

import SwiftUI
import RealityKit

struct Lab008: View {

    // 1. Create an entity that will be anchored to the head
    @State var headTrackedEntity: Entity = {
        let headAnchor = AnchorEntity(.head)
        return headAnchor
    }()

    var body: some View {
        RealityView { content, attachments in

            // 2. Create a model to attach to the tracked entity
            // Set the Z position to push the model away from the user
            let model = ModelEntity(
                mesh: .generateSphere(radius: 0.1),
                materials: [SimpleMaterial(color: .black, isMetallic: false)])
            model.position = SIMD3(x: 0, y: 0, z: -1.5)
            model.scale = SIMD3(x: -1, y: 1, z: 1) // flip this inside out

            // Bonus: add an attachment to the model
            if let attachmentEntity = attachments.entity(for: "AttachmentContent") {
                attachmentEntity.scale = .init(repeating: 2.0)
                attachmentEntity.components[BillboardComponent.self] = .init()
                model.addChild(attachmentEntity)
            }
            headTrackedEntity.addChild(model)

            // 3. Make sure to add the head tracked entity to the scene graph
            content.add(headTrackedEntity)

        } update: { content, attachments in
            //...
        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("👀")
                    .font(.extraLargeTitle2)
            }
        }
    }
}

#Preview {
    Lab008()
}
