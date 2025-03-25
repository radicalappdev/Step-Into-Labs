//  Step Into Vision - Labs
//
//  Title: Lab042
//
//  Subtitle: Second pass at an Entity Spawner
//
//  Description: Using Components and Systems to create an entity spawner system
//
//  Type: Space
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
                // Skip if this is the spawner entity
                if value.entity.components[EntitySpawnerComponent.self] != nil {
                    return
                }
                value.entity.isEnabled = false
            }
    }

}

#Preview {
    Lab042()
}
