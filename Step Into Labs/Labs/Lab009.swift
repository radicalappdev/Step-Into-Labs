//  Step Into Vision - Labs
//
//  Title: Lab009
//
//  Subtitle: A spooky time for visionOS developers
//
//  Description: What really scares us?
//
//  Type: Full Space
//
//  Created by Joseph Simpson on 10/27/24.

import SwiftUI
import RealityKit

struct Lab009: View {

    @State var headTrackedEntity: Entity = {
        let headAnchor = AnchorEntity(.head)
        return headAnchor
    }()

    @State var leftHandTrackedEntity: Entity = {
        let handAnchor = AnchorEntity(.hand(.left, location: .aboveHand))
        return handAnchor
    }()

    @State var rightHandTrackedEntity: Entity = {
        let handAnchor = AnchorEntity(.hand(.right, location: .aboveHand))
        return handAnchor
    }()

    var body: some View {
        RealityView { content, attachments in

            if let attachmentHead = attachments.entity(for: "AttachmentHead") {
                attachmentHead.position = SIMD3(x: 0, y: 0, z: -1.5)
                attachmentHead.scale = .init(repeating: 2.0)
                attachmentHead.components[BillboardComponent.self] = .init()
                headTrackedEntity.addChild(attachmentHead)
            }
            content.add(headTrackedEntity)


            if let attachmentLeft = attachments.entity(for: "AttachmentLeftHand") {
                attachmentLeft.components[BillboardComponent.self] = .init()
                leftHandTrackedEntity.addChild(attachmentLeft)
            }
            content.add(leftHandTrackedEntity)


            if let attachmentRight = attachments.entity(for: "AttachmentRightHand") {
                attachmentRight.components[BillboardComponent.self] = .init()
                rightHandTrackedEntity.addChild(attachmentRight)
            }
            content.add(rightHandTrackedEntity)

        } update: { content, attachments in


        } attachments: {

            Attachment(id: "AttachmentHead") {
                connectionLost
            }

            Attachment(id: "AttachmentLeftHand") {
                inputLost
            }

            Attachment(id: "AttachmentRightHand") {
                inputLost
            }

        }
    }

    var connectionLost: some View {
        VStack(spacing: 12) {
            Text("Lost Connection")
                .font(.extraLargeTitle2)
            Text("The session will resume automatically when the connection improves.")
            Button("Close") {
                print("Reconnecting...")
            }
            .buttonBorderShape(.roundedRectangle(radius: 12))
            .background(.gray)

        }
        .frame(width: 960 , height: 520  )
        .background(.gray)
        .clipShape(.rect(cornerRadius: 12))
    }

    var inputLost: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.white)
            VStack(alignment: .leading) {
                Text("Input temporarily not working")
                    .font(.headline)
                Text("Trying to reconnect, please wait")
            }
        }
        .padding()
        .glassBackgroundEffect()
        .clipShape(.capsule(style: .circular))
    }
}

#Preview {
    Lab009()
}
