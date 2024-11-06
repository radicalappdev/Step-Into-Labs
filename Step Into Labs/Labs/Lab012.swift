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


    @State var handTrackedEntity: Entity = {
        let handAnchor = AnchorEntity(.hand(.left, location: .palm))
        return handAnchor
    }()

    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "Lab012Scene", in: realityKitContentBundle) {
                content.add(scene)


                if let subject = scene.findEntity(named: "Subject") {
                    subject.components[BillboardComponent.self] = .init()

                    handTrackedEntity.addChild(subject)
                    content.add(handTrackedEntity)

                }


            }

        } update: { content, attachments in

        } attachments: {

        }
    }
}

#Preview {
    Lab012()
}
