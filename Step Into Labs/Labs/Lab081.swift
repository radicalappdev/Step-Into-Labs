//  Step Into Vision - Labs
//
//  Title: Lab081
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 9/10/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab081: View {
    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "FeatheredMatLab", in: realityKitContentBundle) else { return }
            content.add(scene)

        }
        .realityViewLayoutBehavior(.centered)
    }
}

#Preview {
    Lab081()
}
