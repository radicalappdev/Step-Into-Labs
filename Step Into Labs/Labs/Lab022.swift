//  Step Into Vision - Labs
//
//  Title: Lab022
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 1/4/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab022: View {

    @State var session: SpatialTrackingSession?
    @State var palmAnchor: Entity = AnchorEntity(.hand(.left, location: .palm))
    @State var subjectEntity: Entity = Entity()

    @State var showMenu = false


    var body: some View {
        RealityView { content, attachments in

            let configuration = SpatialTrackingSession.Configuration(
                tracking: [.hand])
            let session = SpatialTrackingSession()
            await session.run(configuration)


            if let scene = try? await Entity(named: "HandMenuLabs", in: realityKitContentBundle) {
                content.add(scene)

                if let subject = scene.findEntity(named: "subject") {
                    subjectEntity = subject

                }
            }

            // Add attachments to anchors
            if let palmMenu = attachments.entity(for: "PalmMenu") {
                palmAnchor.addChild(palmMenu)
                palmMenu.setPosition([0 ,0.025 ,0], relativeTo: palmAnchor)
                palmMenu.components.set(BillboardComponent())
                content.add(palmAnchor)
            }



        } update: { content, attachments in



        } attachments: {
            Attachment(id: "PalmMenu") {
                Toggle(isOn: $showMenu.animation(), label: {
                    Image(systemName: showMenu ? "hand.raised.fill" : "hand.raised")
                })
                .toggleStyle(.button)
                .glassBackgroundEffect()
            }
        }
        .persistentSystemOverlays(.hidden)
        .upperLimbVisibility(.hidden)

    }


}

#Preview {
    Lab022()
}
