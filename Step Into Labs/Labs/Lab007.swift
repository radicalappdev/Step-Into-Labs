//  Step Into Vision - Labs
//
//  Title: Lab007
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 10/17/24.

import SwiftUI
import RealityKit

struct Lab007: View {

    // 1. Set up a tracked entity with an anchor
    // RealityKit will update this in real time
    // No need for ARKit or hand tracking
    @State var handTrackedEntity: Entity = {
        let handAnchor = AnchorEntity(.hand(.left, location: .aboveHand))
        return handAnchor
    }()

    var body: some View {
        RealityView { content, attachments in

            // Make sure to add the hand tracked entity to the scene graph
            content.add(handTrackedEntity)

            // 3.  Load the attachment
            if let attachmentEntity = attachments.entity(for: "AttachmentContent") {

                // Add the billboard component to keep facing the user
                attachmentEntity.components[BillboardComponent.self] = .init()

                // 4.  Add the attachment as a child of the tracked entity
                handTrackedEntity.addChild(attachmentEntity)

            }

        } update: { content, attachments in
            // ...
        } attachments: {

            // 2. Create the attachment view
            Attachment(id: "AttachmentContent") {
                HStack(spacing: 12) {
                    Button(action: {
                        print("Button one pressed")
                    }, label: {
                        Text("One")

                    })

                    Button(action: {
                        print("Button two pressed")
                    }, label: {
                        Text("Two")

                    })
                }
            }

        }
    }
}

#Preview {
    Lab007()
}
