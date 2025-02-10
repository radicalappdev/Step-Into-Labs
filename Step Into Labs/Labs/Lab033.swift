//  Step Into Vision - Labs
//
//  Title: Lab033
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 2/10/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab033: View {
    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "TeleportLaps", in: realityKitContentBundle) {
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

#Preview {
    Lab033()
}
