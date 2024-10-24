//  Step Into Vision - Labs
//
//  Title: Lab007
//
//  Subtitle: Anchor an attachment to a hand
//
//  Description: Create a tracked entity that will update based on the anchor, then child an attachment entity to it. No need for hand tracking or ARKit.
//
//  Type: Space
//
//  Created by Joseph Simpson on 10/17/24.
//
//  Special Thanks to @JohnAdams_IV on X for prompting me to build this lab.

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

    @State var scaler: Float = 1.0
    @State var target: Entity?


    var body: some View {
        RealityView { content, attachments in

            let model = ModelEntity(
                mesh: .generateSphere(radius: 0.1),
                materials: [SimpleMaterial(color: .black, isMetallic: false)])
            model.position = SIMD3(x: 0.8, y: 1, z: -2)
            target = model
            content.add(model)


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

            print("Scaling target: \(scaler)")
            target?.scale = .init(repeating: scaler)

        } attachments: {

            // 2. Create the attachment view
            Attachment(id: "AttachmentContent") {
                HStack(spacing: 12) {
                    Button(action: {
                        print("Button one pressed")
                        scaler -= 0.5
                    }, label: {
                        Text("One")

                    })

                    Button(action: {
                        print("Button two pressed")
                        scaler += 0.5
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
