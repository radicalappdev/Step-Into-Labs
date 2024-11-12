//  Step Into Vision - Labs
//
//  Title: Lab013
//
//  Subtitle: Using targetedToEntity with a Query
//
//  Description: Instead of using the broad targetedToAnyEntity modifier, let's try to use targetedToEntity to query components with a custom component.
//
//  Type: Space
//
//  Created by Joseph Simpson on 11/12/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab013: View {

    init() {
        // Make sure to register the component!
        AllowGestures.registerComponent()
    }

    var body: some View {
        RealityView { content in

            // Load the scene from the Reality Kit bundle
            if let scene = try? await Entity(named: "Lab013Scene", in: realityKitContentBundle) {
                content.add(scene)

                // Contains a red sphere and a green sphere. Only the green sphere has the new component.

            }
        }
        .gesture(tapExample)
    }

    var tapExample: some Gesture {
        TapGesture()
        // We can target the gesture only on entites with the AllowGestures component.
            .targetedToEntity(where: .has(AllowGestures.self))
            .onEnded { value in

                // Just a bit of visual feedback that the gesture is firing
                value.entity.position.y += 0.1
            }
    }

}

#Preview {
    Lab013()
}
