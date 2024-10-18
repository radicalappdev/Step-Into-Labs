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

    // Set up a tracked entity with an anchor
    // RealityKit will update this in real time
    // No need to ARKit or hand tracking
    @State var handTrackedEntity: Entity = {
        let handAnchor = AnchorEntity(.hand(.left, location: .aboveHand))
        return handAnchor
    }()

    var body: some View {
        RealityView { content, attachments in

            content.add(handTrackedEntity)


            // Load the attachment
            if let attachmentEntity = attachments.entity(for: "AttachmentContent") {


                // Add the billboard component to keep facing the user
                attachmentEntity.components[BillboardComponent.self] = .init()

                // Add the attachment as a child of the tracked entity
                handTrackedEntity.addChild(attachmentEntity)

            }

        } update: { content, attachments in
            // ...
        } attachments: {

            Attachment(id: "AttachmentContent") {
                VStack {
                    Text("Hand anchored menu")
                        .font(.largeTitle)
                        .padding(18)

                    Button(action: {
                        print("something happened")
                    }, label: {
                        Text("Test")

                    })

                }
                .padding()
                .glassBackgroundEffect()
                .cornerRadius(12)

            }

        }
    }
}

#Preview {
    Lab007()
}
