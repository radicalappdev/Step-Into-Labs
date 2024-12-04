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
//  Created by Joseph Simpson on 12/4/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab016: View {


    var body: some View {
        RealityView { content, attachments in

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
