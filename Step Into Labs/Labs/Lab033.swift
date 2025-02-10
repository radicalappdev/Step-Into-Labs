//  Step Into Vision - Labs
//
//  Title: Lab033
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 2/10/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab033: View {

    @State var sceneContent: Entity?

    var teleportTap: some Gesture {
        SpatialTapGesture()
            .targetedToAnyEntity()
            .onEnded { value in

                print("TELEPORTING TO: \(value.entity.name)" )

                guard let sceneContent = self.sceneContent else { return }

                // Calculate the vector from the origin to the tapped position
                let vectorToTap = value.convert(value.location3D, from: .local, to: sceneContent)

                // Normalize the vector to get a direction from the origin to the tapped position
                let direction = normalize(vectorToTap)

                // Calculate the distance (or magnitude) between the origin and the tapped position
                let distance = length(vectorToTap)

                // Calculate the new position by inverting the direction multiplied by the distance
                let newPosition = -direction * distance

                // Update sceneOffset's X and Z components, leave Y as it is
                let teleportPosition: SIMD3<Float> = [newPosition.x, 0, newPosition.z]

                print("TELEPORTING POS: \(teleportPosition)" )
                sceneContent.position = teleportPosition


            }
    }

    var body: some View {
        RealityView { content in

            if let scene = try? await Entity(named: "TeleportLaps", in: realityKitContentBundle) {
                content.add(scene)

                // Get the scene content and stash it in state
                if let sceneContent = scene.findEntity(named: "SceneContent") {
                    self.sceneContent = sceneContent
                }
            }

        }
        .gesture(teleportTap)
    }
}

#Preview {
    Lab033()
}
