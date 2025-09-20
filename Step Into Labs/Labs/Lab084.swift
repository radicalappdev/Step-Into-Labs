//  Step Into Vision - Labs
//
//  Title: Lab084
//
//  Subtitle: Background Glass as Material
//
//  Description: Using the BlurredBackground Shader Graph Node.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 9/20/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab084: View {
    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "BackgroundGlass", in: realityKitContentBundle) else { return }
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
    Lab084()
}
