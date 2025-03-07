//  Step Into Vision - Labs
//
//  Title: Lab038
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 3/7/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab038: View {
    @State var orbIsActive: Bool = false
    @State var orbOverlay = Entity()
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
            guard let portalSphereScene = try? await Entity(named: "PortalBall", in: realityKitContentBundle) else { return }
            rootEntity.addChild(portalSphereScene)
            portalSphereScene.position.y = -0.28
            if let portalSphere = portalSphereScene.findEntity(named: "PortalSphere") {
                // Replace the material with PortalMaterial
                portalSphere.components[ModelComponent.self]?.materials[0] = PortalMaterial()

                // We also need to add a PortalComponent that targets the portalContentRoot
                portalSphere.components.set(PortalComponent(target: portalContentRoot))
            }

            // Handle the overlay sphere
            if let overlay = portalSphereScene.findEntity(named: "Overlay") {
                // Stash this in state so we can target a gesture to it
                orbOverlay = overlay
            }


            // 4. We'll load some content to add to the portalContentRoot
            guard let scene = try? await Entity(named: "TeleportLabs", in: realityKitContentBundle) else { return }

            portalContentRoot.addChild(scene)
            scene.position.y = -1.4

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
        .gesture(longPressGesture)
    }

    var longPressGesture: some Gesture {
        LongPressGesture()
            .targetedToEntity(orbOverlay)
            .onEnded { value in
                let subject = value.entity
                orbIsActive.toggle()

                if var mat = subject.components[ModelComponent.self]?.materials.first as? PhysicallyBasedMaterial {
                    mat.blending = .transparent(opacity: orbIsActive ? 0.2 : 1.0)
                    subject.components[ModelComponent.self]?.materials[0] = mat
                }

            }
    }
}

#Preview {
    Lab038()
}
