//  Step Into Vision - Labs
//
//  Title: Lab043
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 3/25/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab043: View {

    init() {
        EntitySpawnerComponent.registerComponent()
        EntitySpawnerSystem.registerSystem()
    }

    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "SpawnerLabResource", in: realityKitContentBundle) {
                content.add(scene)

                // The entity we'll clone in the different spawners.
                if let subject = scene.findEntity(named: "Subject") {

                }

                // This entity has a material we can use for the base of the spawners
                if let subject = scene.findEntity(named: "Base") {

                }

                // This entity has a material we can use to visualize the shape of the spawners
                if let subject = scene.findEntity(named: "ShapeVis") {

                }


            }

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("wow")
            }
        }
        .gesture(tap)

    }

    var tap: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                value.entity.isEnabled = false
            }
    }

}
#Preview {
    Lab043()
}
