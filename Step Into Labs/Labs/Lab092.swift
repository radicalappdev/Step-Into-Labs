//  Step Into Vision - Labs
//
//  Title: Lab092
//
//  Subtitle:
//
//  Description:
//
//  Type:
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
    Lab092()
}


