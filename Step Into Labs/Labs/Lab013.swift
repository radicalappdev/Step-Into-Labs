//  Step Into Vision - Labs
//
//  Title: Lab013
//
//  Subtitle: Using targetedToEntity with a Query
//
//  Description: Instead of using the broad targetedToAnyEntity modifier, let's try to use targetedToEntity to query components with a custom component.
//
//  Type:
//
//  Created by Joseph Simpson on 11/11/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab013: View {

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

                // The more spheres will load on the right. These do not have the Breath Component.
            }
        }
        .gesture(tapExample)
    }

    // Create our gesture
    var tapExample: some Gesture {
        TapGesture()
        // Make sure to use this line to target entities with a custom component
            .targetedToEntity(where: .has(BreathComponent.self))
            .onEnded { value in
                value.entity.position.x += 0.5
            }
    }
}

#Preview {
    Lab013()
}
