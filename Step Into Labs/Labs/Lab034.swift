//  Step Into Vision - Labs
//
//  Title: Lab034
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 2/19/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab034: View {

    init() {
        // Make sure to register the component!
        TeleportTargetComponent.registerComponent()
    }

    @State var sceneContent: Entity?

    var body: some View {
        RealityView { content in

            if let scene = try? await Entity(named: "TeleportLabs", in: realityKitContentBundle) {
                content.add(scene)

                // Get the scene content and stash it in state
                if let sceneContent = scene.findEntity(named: "Root") {
                    self.sceneContent = sceneContent
                }

                
            }

        }
        .gesture(tapExample)

    }

    var tapExample: some Gesture {
        SpatialTapGesture()
            .targetedToEntity(where: .has(TeleportTargetComponent.self))
            .onEnded { value in

                guard let sceneContent = self.sceneContent else { return }

                guard let teleportTC = value.entity.components[TeleportTargetComponent.self] else { return }

                if(teleportTC.targetType == .waypoint) {

                } else if (teleportTC.targetType == .viewpoint) {

                }

                // Calculate the vector from the origin to the tapped position
                let vectorToTap = value.entity.position

                // Normalize the vector to get a direction from the origin to the tapped position
                let direction = normalize(vectorToTap)

                // Calculate the distance (or magnitude) between the origin and the tapped position
                let distance = length(vectorToTap)

                // Calculate the new position by inverting the direction multiplied by the distance
                let newPosition = -direction * distance

                // Update sceneOffset's X and Z components, leave Y as it is
                sceneContent.position.x = newPosition.x
                sceneContent.position.z = newPosition.z

            }
    }
}

#Preview {
    Lab034()
}
