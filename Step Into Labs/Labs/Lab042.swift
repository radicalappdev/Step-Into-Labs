//  Step Into Vision - Labs
//
//  Title: Lab042
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 3/21/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab042: View {

    init() {
        EntitySpawnerComponent.registerComponent()
        EntitySpawnerSystem.registerSystem()
    }


    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "SpawnerLab", in: realityKitContentBundle) {
                content.add(scene)

                print("Scene added")


            }

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("wow")
            }
        }
        .gesture(tap)
        .modifier(DragGestureImproved())
        .modifier(MagnifyGestureImproved())
        .modifier(RotateGesture3DImproved())


    }

    var tap: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                // Skip if this is the original (spawner) entity
                if value.entity.components[EntitySpawnerComponentLab016.self] != nil {
                    return
                }
                value.entity.isEnabled = false
            }
    }

}

#Preview {
    Lab042()
}
