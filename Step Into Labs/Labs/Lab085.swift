//  Step Into Vision - Labs
//
//  Title: Lab085
//
//  Subtitle: Background Glass Material Showcase
//
//  Description: Using the BlurredBackground material to build a showcase object.
//
//  Type: Space
//
//  Created by Joseph Simpson on 9/22/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab085: View {
    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "BackgroundGlassShowcase", in: realityKitContentBundle) else { return }
            content.add(scene)

            // Add ManipulationComponent to every entity that already has an InputTargetComponent (added in RCP)
            var stack: [Entity] = Array(content.entities)
            await MainActor.run {
                while let entity = stack.popLast() {
                    if entity.components.has(InputTargetComponent.self) &&
                        !entity.components.has(ManipulationComponent.self) {
                        entity.components.set(ManipulationComponent())
                    }
                    stack.append(contentsOf: entity.children)
                }
            }

        }
    }
}

#Preview {
    Lab085()
}
