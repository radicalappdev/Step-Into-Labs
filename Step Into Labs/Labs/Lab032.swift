//  Step Into Vision - Labs
//
//  Title: Lab032
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 2/7/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab032: View {
    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "Whales", in: realityKitContentBundle) {
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
    Lab032()
}
