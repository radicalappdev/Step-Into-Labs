//  Step Into Vision - Labs
//
//  Title: Lab026
//
//  Subtitle: Using Dynamic Lights and Shadows with Passthrough
//
//  Description: We can use ShadowReceivingOcclusionSurface to enable virtual lights and shadows to affect our real space.
//
//  Type: Space
//
//  Created by Joseph Simpson on 1/17/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab026: View {
    var body: some View {
        RealityView { content in

            if let scene = try? await Entity(named: "DynamicLightTest", in: realityKitContentBundle) {
                content.add(scene)
            }

        }
        .modifier(DragGestureImproved())
    }
}

#Preview {
    Lab026()
}
