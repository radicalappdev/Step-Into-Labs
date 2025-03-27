//  Step Into Vision - Labs
//
//  Title: Lab044
//
//  Subtitle: Component inheritance?
//
//  Description: Exploring some oddness with RealityKit components.
//
//  Type: Space
//
//  Created by Joseph Simpson on 3/27/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab044: View {

    @State var leftExample = Entity()
    @State var rightExample = Entity()
    @State var rightSyncExample = Entity()

    var body: some View {
        RealityView { content, attachments in

            guard let scene = try? await Entity(named: "InputOddness", in: realityKitContentBundle)  else { return }
            content.add(scene)

            guard let standParentExample = scene.findEntity(named: "StandParentExample") ,
                    let standWithoutChildren = scene.findEntity(named: "StandWithoutChildren"),
                    let transformParentExample = scene.findEntity(named: "TransformParentExample")
            else { return }

            
            standParentExample.components.set(HoverEffectComponent())
            leftExample = standParentExample

            standWithoutChildren.components.set(HoverEffectComponent())
            rightExample = standWithoutChildren
            rightSyncExample = transformParentExample


        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
        .gesture(dragGestureLeft)
        .gesture(dragGestureRight)
    }

    var dragGestureLeft: some Gesture {
        DragGesture()
            .targetedToEntity(leftExample)
            .onChanged { value in
                value.entity.position = value.convert(value.location3D, from: .local, to: value.entity.parent!)
            }
    }

    var dragGestureRight: some Gesture {
        DragGesture()
            .targetedToEntity(rightExample)
            .onChanged { value in
                value.entity.position = value.convert(value.location3D, from: .local, to: value.entity.parent!)
                rightSyncExample.transform = value.entity.transform
            }
    }

}

#Preview {
    Lab044()
}


