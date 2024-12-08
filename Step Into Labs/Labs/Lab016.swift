//  Step Into Vision - Labs
//
//  Title: Lab016
//
//  Subtitle: 
//
//  Description:
//
//  Type: Space
//
//  Created by Joseph Simpson on 12/8/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab016: View {


    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "BuildingBlocks/StepDome", in: realityKitContentBundle) {
                content.add(scene)

                print("Scene added")


            }

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("wow")
            }
        }

    }

}

#Preview {
    Lab016()
}
