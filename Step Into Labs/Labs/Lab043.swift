//  Step Into Vision - Labs
//
//  Title: Lab043
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 3/11/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab043: View {
    var body: some View {
        RealityView { content, attachments in

            guard let scene = try? await Entity(named: "Mirror", in: realityKitContentBundle) else { return }
            content.add(scene)

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
    }
}

#Preview {
    Lab043()
}
