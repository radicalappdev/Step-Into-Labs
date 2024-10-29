//  Step Into Vision - Labs
//
//  Title: Lab011
//
//  Subtitle: Playing with Occlusion Material
//
//  Description: Making myself a little fort and playing with occlusion material.
//
//  Type: Space
//
//  Created by Joseph Simpson on 10/29/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab011: View {
    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "Lab011Scene", in: realityKitContentBundle) {
                content.add(scene)

            }

        } update: { content, attachments in

        } attachments: {

        }
    }
}

#Preview {
    Lab011()
}
