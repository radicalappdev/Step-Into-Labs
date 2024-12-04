//  Step Into Vision - Labs
//
//  Title: Lab016
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 12/4/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab016: View {

    @State var vis: Visibility = .automatic

    @State var handTrackedEntity: Entity = {
        let handAnchor = AnchorEntity(.hand(.left, location: .aboveHand))
        return handAnchor
    }()

    var body: some View {
        RealityView { content, attachments in

            let model = ModelEntity(
                mesh: .generateSphere(radius: 0.1),
                materials: [SimpleMaterial(color: .black, isMetallic: false)])
            model.position = SIMD3(x: 0.8, y: 1, z: -2)

            content.add(model)

            content.add(handTrackedEntity)

            if let attachmentEntity = attachments.entity(for: "AttachmentContent") {
                attachmentEntity.components[BillboardComponent.self] = .init()

                handTrackedEntity.addChild(attachmentEntity)

            }

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                HStack(spacing: 12) {
                    Button(action: {
                        vis = .hidden
                    }, label: {
                        Image(systemName: "eye.slash.fill")

                    })

                    Button(action: {
                        vis = .visible
                    }, label: {
                        Image(systemName: "eye.fill")
                    })
                }
            }
        }
        .persistentSystemOverlays(vis)
    }

}

#Preview {
    Lab016()
}
