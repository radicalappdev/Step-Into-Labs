//  Step Into Vision - Labs
//
//  Title: Lab092
//
//  Subtitle: Manipulation from Input Target
//
//  Description: Adding a helper function to quickly assign manipulation components to any entity with an input target component.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 10/23/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab092: View {
    var body: some View {
        RealityView { content in
            guard let scene = try? await Entity(named: "GestureLabs", in: realityKitContentBundle) else { return }
            scene.position.y = -0.4
            content.add(scene)

            // The entities in this scene alread have Input Target Components that were added in Reality Composer Pro
            await content.addManipulationToInputTargets()
        }
    }
}

#Preview {
    Lab092()
}
