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

            if let scene = try? await Entity(named: "LetMeTalkToWhales", in: realityKitContentBundle) {
                content.add(scene)

                if let probe = scene.findEntity(named: "Probe") {
                    probe.setPosition([10, 12, -20], relativeTo: nil)
                }

            }

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
        .modifier(DragGestureImproved())
        .modifier(MagnifyGestureImproved())
        .modifier(RotateGesture3DImproved())
    }
}

#Preview {
    Lab032()
}
