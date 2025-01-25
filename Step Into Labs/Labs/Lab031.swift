//  Step Into Vision - Labs
//
//  Title: Lab031
//
//  Subtitle:
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

            let subject = ModelEntity(
                mesh: .generateSphere(radius: 0.1),
                materials: [SimpleMaterial(color: .stepRed, isMetallic: false)])
            subject.position = SIMD3(x: 0.8, y: 1, z: -2)
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
    Lab031()
}
