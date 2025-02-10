//  Step Into Vision - Labs
//
//  Title: Lab033
//
//  Subtitle: Teleportation with SpatialTapGesture
//
//  Description: We can't move the player/user entity in RealityKit, but we can move the world around them instead.
//
//  Type: Space
//
//  Created by Joseph Simpson on 2/10/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab033: View {

    @State var sceneContent: Entity?
    @State var groundEntity: Entity = Entity()

    var body: some View {
        RealityView { content in

            if let scene = try? await Entity(named: "TeleportLabs", in: realityKitContentBundle) {
                content.add(scene)

                // Get the scene content and stash it in state
                if let sceneContent = scene.findEntity(named: "Root") {
                    self.sceneContent = sceneContent
                }

                // Get the ground entity from the dome. We'll use this to target our gesture on this entity only.
                if let groundEntity = scene.findEntity(named: "Ground_01") {
                    self.groundEntity = groundEntity
                }
            }

        }
        .gesture(teleportTap)
    }

    var teleportTap: some Gesture {
        SpatialTapGesture()
            .targetedToEntity(groundEntity)
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
}

#Preview {
    Lab033()
}
