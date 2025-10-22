//  Step Into Vision - Labs
//
//  Title: Lab091
//
//  Subtitle: Light the Beacon
//
//  Description: Just a bit of fun while I wait for my Apple Vision Pro M5 to arrive.
//
//  Type: Space
//
//  Created by Joseph Simpson on 10/22/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab091: View {
    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "SaveUs", in: realityKitContentBundle) else { return }
            content.add(scene)

            guard let anchorPoint = scene.findEntity(named: "Anchor") else { return }
            let attachment = ViewAttachmentComponent(rootView: beaconFace)
            anchorPoint.components.set(attachment)

        }
    }

    var beaconFace: some View {
        VStack {
            Image(systemName: "vision.pro")
                .font(.extraLargeTitle2)
        }
    }
}

#Preview {
    Lab091()
}
