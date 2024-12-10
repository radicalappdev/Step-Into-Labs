//  Step Into Vision - Labs
//
//  Title: Lab016
//
//  Subtitle: Creating an entity spawner system
//
//  Description:
//
//  Type: Space
//
//  Created by Joseph Simpson on 12/8/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab016: View {

    init() {
        EntitySpawnerComponent.registerComponent()
        EntitySpawnerSystem.registerSystem()
    }


    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "Lab016Scene", in: realityKitContentBundle) {
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
        

    }

    var tap: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                // Skip if this is the original (spawner) entity
                if value.entity.components[EntitySpawnerComponent.self] != nil {
                    return
                }
                value.entity.isEnabled = false
            }
    }

}

#Preview {
    Lab016()
}
