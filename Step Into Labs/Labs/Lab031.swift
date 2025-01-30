//  Step Into Vision - Labs
//
//  Title: Lab031
//
//  Subtitle: Faking some Stage Lights
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 1/24/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab031: View {
    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "DanceLights", in: realityKitContentBundle) {
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
    Lab031()
}
