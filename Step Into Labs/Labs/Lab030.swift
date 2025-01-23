//  Step Into Vision - Labs
//
//  Title: Lab030
//
//  Subtitle: The Basics of RealityKit Behaviors
//
//  Description: A few simple examples of RealityKit behaviors in Reality Composer Pro.
//
//  Type: Space
//
//  Created by Joseph Simpson on 1/23/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab030: View {
    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "BehaviorBasics", in: realityKitContentBundle) {
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
    Lab030()
}
