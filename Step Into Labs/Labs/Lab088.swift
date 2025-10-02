//  Step Into Vision - Labs
//
//  Title: Lab088
//
//  Subtitle: Animated Particles
//
//  Description: We can provide an image that contains a grid of sub-images, and use it to generate animated effects.
//  Bird Sprite Sheet: https://opengameart.org/content/a-bird-animation
//
//  Type:
//
//  Created by Joseph Simpson on 10/2/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab088: View {
    var body: some View {
        VStack {
            Spacer()
            RealityView { content in

                guard let scene = try? await Entity(named: "AnimatedBirdParticle", in: realityKitContentBundle) else { return }
                content.add(scene)

            }
            .realityViewLayoutBehavior(.flexible)
            .preferredWindowClippingMargins(.all, 200)
        }
        }
}

#Preview {
    Lab088()
}
