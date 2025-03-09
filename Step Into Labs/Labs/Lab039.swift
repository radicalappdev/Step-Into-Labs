//  Step Into Vision - Labs
//
//  Title: Lab039
//
//  Subtitle: Portals in Immersive Spaces
//
//  Description: In immersive spaces, portal contents share the same coordinate space as the main scene.
//
//  Type: Space
//
//  Created by Joseph Simpson on 3/9/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab039: View {

    var body: some View {
        RealityView { content in

            // 1. The root for our scene *outside* of the portal
            let rootEntity = Entity()
            content.add(rootEntity)

            // 2. The root for the content that will appear *inside* the portal
            // We need a WorldComponent here
            let portalContentRoot = Entity()
            portalContentRoot.components.set(WorldComponent())
            rootEntity.addChild(portalContentRoot)

            guard let portalSphereScene = try? await Entity(named: "PortalPlayground", in: realityKitContentBundle) else { return }
            rootEntity.addChild(portalSphereScene)

            // 3. We need something to render the portal on
            // We'll get the portals entity use each child
            if let portals = portalSphereScene.findEntity(named: "Portals")?.children {
                print(portals)

                for portal in portals {
                    // Replace the material with PortalMaterial
                    portal.components[ModelComponent.self]?.materials[0] = PortalMaterial()

                    // We also need to add a PortalComponent that targets the portalContentRoot
                    portal.components.set(PortalComponent(target: portalContentRoot))

                }
            }

            // 4. We'll load some content to add to the portalContentRoot
            guard let scene = try? await Entity(named: "TeleportLabs", in: realityKitContentBundle) else { return }
            portalContentRoot.addChild(scene)

        }
        .modifier(DragGestureImproved())
        .modifier(MagnifyGestureImproved())
    }
}

#Preview {
    Lab039()
}
