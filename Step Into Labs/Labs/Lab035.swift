//  Step Into Vision - Labs
//
//  Title: Lab035
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 2/20/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab035: View {

    // Create a new pivot entity. We'll add our scene root as a child to this.
    @State var scenePivot: Entity = Entity()
    @State var sceneContent: Entity?

    var body: some View {
        RealityView { content in
            if let scene = try? await Entity(named: "TeleportLabs", in: realityKitContentBundle) {
                content.add(scene)
                content.add(self.scenePivot)

                // Get the scene content and stash it in state
                if let sceneContent = scene.findEntity(named: "Root") {
                    self.scenePivot.addChild(sceneContent)
                    self.sceneContent = sceneContent
                }

            }
        }
        .gesture(teleportTapViewpoint)
    }

    var teleportTapViewpoint: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in

                print("teleporting")

                guard let sceneContent = self.sceneContent else { return }

                print("teleporting sceneContent")

                // Calculate the vector from the origin to the tapped position
                let vectorToTap = value.entity.position

                // Normalize the vector to get a direction from the origin to the tapped position
                let direction = normalize(vectorToTap)

                // Calculate the distance (or magnitude) between the origin and the tapped position
                let distance = length(vectorToTap)

                // Calculate the new position by inverting the direction multiplied by the distance
                let newPosition = -direction * distance


                // Move the sceneContent relative to the scenePivot
                // Update sceneOffset's X and Z components, leave Y as it is
                sceneContent.setPosition([newPosition.x, 0, newPosition.z], relativeTo: scenePivot)


                // Get the viewpoint's orientation in world space
                let entityOrientation = value.entity.transform.rotation

                // To make the player face the same direction as the viewpoint,
                // we need to rotate the world in the opposite direction
                let inverseOrientation = entityOrientation.inverse

                // set the orientation on the pivot entity to handle scene rotation
                scenePivot.orientation = inverseOrientation


            }
    }
}

#Preview {
    Lab035()
}
