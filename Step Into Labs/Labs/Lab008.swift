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

    @State var headTrackedEntity: Entity = {
        let headAnchor = AnchorEntity(.head)
        return headAnchor
    }()


    var body: some View {
        RealityView { content, attachments in

            let model = ModelEntity(
                mesh: .generateSphere(radius: 0.1),
                materials: [SimpleMaterial(color: .black, isMetallic: false)])
            model.position = SIMD3(x: 0, y: 0, z: -2)
            model.scale = SIMD3(x: -1, y: 1, z: 1)

            content.add(model)


            // Make sure to add the hand tracked entity to the scene graph
            content.add(headTrackedEntity)

            // 3.  Load the attachment
            if let attachmentEntity = attachments.entity(for: "AttachmentContent") {

                attachmentEntity.scale = .init(repeating: 3.0)

                // Add the billboard component to keep facing the user
                attachmentEntity.components[BillboardComponent.self] = .init()


                // 4.  Add the attachment as a child of the tracked entity
                model.addChild(attachmentEntity)

            }

            headTrackedEntity.addChild(model)

        } update: { content, attachments in
            //...
        } attachments: {
            Attachment(id: "AttachmentContent") {
                HStack(spacing: 12) {
                    Text("👀")
                        .font(.extraLargeTitle2)
                }
            }
        }
    }
}

#Preview {
    Lab008()
}
