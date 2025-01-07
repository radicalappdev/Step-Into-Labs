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
    @State var palmEntity: Entity = Entity()
    @State var menuOptions: Entity = Entity()

    @State var showMenu = false


    var body: some View {
        RealityView { content, attachments in

            let configuration = SpatialTrackingSession.Configuration(
                tracking: [.hand])
            let session = SpatialTrackingSession()
            await session.run(configuration)


            if let scene = try? await Entity(named: "HandMenuLabs", in: realityKitContentBundle) {
                content.add(scene)

                if let palm = scene.findEntity(named: "LeftPalm") {
                    palmEntity = palm

                }

                if let leftIndex = scene.findEntity(named: "LeftIndex") {
                    menuOptions = leftIndex

                }

            }




        } update: { content, attachments in

            if(showMenu) {
                menuOptions.isEnabled = showMenu
            }

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
        .persistentSystemOverlays(.hidden)
//        .upperLimbVisibility(.hidden)
        .gesture(tapPalm)

    }

    var tapPalm: some Gesture {
        TapGesture()
            .targetedToEntity(palmEntity)
            .onEnded { value in
                showMenu.toggle()
            }
    }
}

#Preview {
    Lab022()
}
