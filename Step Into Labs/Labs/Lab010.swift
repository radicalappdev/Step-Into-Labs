//  Step Into Vision - Labs
//
//  Title: Lab010
//
//  Subtitle: Learning the basics of Systems
//
//  Description: Creating a custom component and system that will add a breathing effect to entities based on the duration entered in the component.
//
//  Type: Space
//
//  Created by Joseph Simpson on 10/24/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab010: View {

    init() {
        BreathComponent.registerComponent()
        BreathSystem.registerSystem()
    }
    
    var body: some View {
        RealityView { content in
            // Load the scene from the Reality Kit bindle
            if let scene = try? await Entity(named: "Lab010Scene", in: realityKitContentBundle) {
                content.add(scene)

                // The scene contains three entities with the new component, all with different duration values.
            }
        }
    }
}

#Preview {
    Lab010()
}
