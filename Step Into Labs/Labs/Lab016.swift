//  Step Into Vision - Labs
//
//  Title: Lab016
//
//  Subtitle: We can hide the system hand menu in Immersive Spaces
//
//  Description: SwiftUI has a modifier called `persistentSystemOverlays` that allows us to hide the system hand menu in Immersive Spaces.
//
//  Type: Space
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

            if let scene = try? await Entity(named: "Lab010Scene", in: realityKitContentBundle) {
                content.add(scene)
            }

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
