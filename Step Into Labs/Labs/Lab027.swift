//  Step Into Vision - Labs
//
//  Title: Lab027
//
//  Subtitle: When a door appears
//
//  Description: Enter.
//
//  Type: Space
//
//  Created by Joseph Simpson on 1/18/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab027: View {
    var body: some View {
        RealityView { content in

            if let scene = try? await Entity(named: "Stacks", in: realityKitContentBundle) {
                content.add(scene)
            }

        }
    }
}

#Preview {
    Lab027()
}
