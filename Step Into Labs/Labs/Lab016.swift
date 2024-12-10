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

//                if let subject = scene.findEntity(named: "StepSphereGreen") {
//                    if var spawner = subject.components[EntitySpawnerComponent.self] {
//                        spawner.Copies = 200
//                        subject.components[EntitySpawnerComponent.self] = spawner
//                    }
//                }

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
                value.entity.isEnabled = false
            }
    }

}

#Preview {
    Lab016()
}
