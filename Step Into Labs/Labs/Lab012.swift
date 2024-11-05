//  Step Into Vision - Labs
//
//  Title: Lab012
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 11/5/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab012: View {

    @State var subjectEntity: Entity? = nil

    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "Lab012Scene", in: realityKitContentBundle) {
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
            .targetedToAnyEntity()
            .onEnded { value in
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
    Lab012()
}
