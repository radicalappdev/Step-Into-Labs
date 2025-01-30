//  Step Into Vision - Labs
//
//  Title: Lab027
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 1/18/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab027: View {
    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "Stacks", in: realityKitContentBundle) {
                content.add(scene)
            }

//            if let scene = try? await Entity(named: "BYOHZ", in: realityKitContentBundle) {
//                content.add(scene)
//            }


        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
    }
}

#Preview {
    Lab027()
}
