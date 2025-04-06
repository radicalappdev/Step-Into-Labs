//  Step Into Vision - Labs
//
//  Title: Lab045
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 4/6/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab045: View {
    var body: some View {
        RealityView { content, attachments in
            let subject = ModelEntity(
                mesh: .generateBox(size: 0.2),
                materials: [SimpleMaterial(color: .stepRed, isMetallic: false)]
            )
            content.add(subject)

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
    }
}

#Preview {
    Lab045()
}
