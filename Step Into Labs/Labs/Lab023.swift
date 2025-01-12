//  Step Into Vision - Labs
//
//  Title: Lab023
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 1/12/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab023: View {
    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "PhysicsPlayground", in: realityKitContentBundle) {
                content.add(scene)

            }

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
    }
}

