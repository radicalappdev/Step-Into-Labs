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


    @State var leftHandTrackedEntity: Entity = {
        let handAnchor = AnchorEntity(.hand(.left, location: .palm))
        return handAnchor
    }()

    @State var rightHandTrackedEntity: Entity = {
        let handAnchor = AnchorEntity(.hand(.right, location: .palm))
        return handAnchor
    }()

    var body: some View {
        RealityView {
 content,
 attachments in

            if let scene = try? await Entity(named: "Lab012Scene", in: realityKitContentBundle) {
                content.add(scene)


                if let subjectLeft = scene.findEntity(named: "SubjectLeft") {
                    leftHandTrackedEntity.addChild(subjectLeft)
                    subjectLeft
                        .setPosition(
                            [0.12, 0.12, 0],
                            relativeTo: leftHandTrackedEntity
                        )
                    content.add(leftHandTrackedEntity)
                }

                if let subjectRight = scene.findEntity(named: "SubjectRight") {
                    rightHandTrackedEntity.addChild(subjectRight)
                    subjectRight
                        .setPosition(
                            [-0.12, 0.12, 0],
                            relativeTo: rightHandTrackedEntity
                        )
                    content.add(rightHandTrackedEntity)
                }


            }

        } update: { content, attachments in

        } attachments: {

        }
        .persistentSystemOverlays(.hidden)
    }
}

#Preview {
    Lab012()
}
