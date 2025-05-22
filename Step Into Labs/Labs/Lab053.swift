//  Step Into Vision - Labs
//
//  Title: Lab053
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 5/22/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab053: View {
    var body: some View {
        RealityView { content, attachments in

            // 1. The root for our scene *outside* of the portal
            let rootEntity = Entity()
            content.add(rootEntity)

            // 2. The root for the content that will appear *inside* the portal
            // We need a WorldComponent here
            let portalContentRoot = Entity()
            portalContentRoot.components.set(WorldComponent())
            rootEntity.addChild(portalContentRoot)

            // 3. An entity that will render the portal
            // We need to use PortalMaterial
            let portalEntity = ModelEntity(
                mesh: .generatePlane(width: 0.4, height: 0.2, cornerRadius: 0.03),
                materials: [PortalMaterial()]
            )
            portalEntity.position.z = -0.175

            // We also need to add a PortalComponent that targets the portalContentRoot
            portalEntity.components.set(PortalComponent(target: portalContentRoot))
            rootEntity.addChild(portalEntity)


            // 4. We'll load some content to add to the portalContentRoot
//            guard let scene = try? await Entity(named: "TeleportLabs", in: realityKitContentBundle) else { return }

            // Let's try loading as an empty scene
            let scene = Entity()

            if let panel = attachments.entity(for: "AttachmentContent") {
                scene.addChild(panel)
                panel.position.y = 1.4
                panel.position.z = -0.4
            }

            portalContentRoot.addChild(scene)
            scene.position.y = -1.4

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                VStack {
                    Text("Testing Attachment in Portals")
                        .font(.title)
                    Button(action: {
                        print("testing")
                    }, label: {
                        Label("Button", image: "eject.fill")
                    })
                }
                    .padding(12)
                    .glassBackgroundEffect()
            }
        }
    }
}

#Preview {
    Lab053()
}
