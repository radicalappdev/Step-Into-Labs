//  Step Into Vision - Labs
//
//  Title: Lab011
//
//  Subtitle: Playing with Occlusion Material
//
//  Description: Making myself a little fort and playing with occlusion material.
//
//  Type: Space
//
//  Created by Joseph Simpson on 10/29/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab011: View {

    @State var subjectEntity: Entity? = nil

    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "Lab011Scene", in: realityKitContentBundle) {
                content.add(scene)

                if let subject = scene.findEntity(named: "Subject") {

                    let mat = OcclusionMaterial()
                    subject.components[ModelComponent.self]?.materials[0] = mat
                    subject.isEnabled = false
                    subjectEntity = subject
                }

            }

        } update: { content, attachments in

        } attachments: {

        }
        .gesture(tapExample)
        .gesture(dragGesture)
    }

    var tapExample: some Gesture {
        TapGesture()
            .targetedToAnyEntity() // 3. make sure to use this line to target entities
            .onEnded { value in
                print("TAPPED", value.entity.name)

                if(value.entity.name == "Wall_2") {
                    subjectEntity?.isEnabled = !subjectEntity!.isEnabled
                }
            }
    }

    var dragGesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in

                if(value.entity.name == "Subject") {

                    let newPost = value.convert(value.location3D, from: .local, to: .scene)

                    // Clamp the values in both X and Y
                    value.entity.position.x = min(max(newPost.x, -0.8), 0.8)
                    value.entity.position.y = min(max(newPost.y, 0.2), 1.8)
                }

            }
            .onEnded { value in
                // do something

            }
    }
}

#Preview {
    Lab011()
}
