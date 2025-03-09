//  Step Into Vision - Labs
//
//  Title: Lab039
//
//  Subtitle:
//
//  Description:
//
//  Type:
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

            // 3. An entity that will render the portal
            if let portalSphere = portalSphereScene.findEntity(named: "PortalSphere") {

                // Replace the material with PortalMaterial
                portalSphere.components[ModelComponent.self]?.materials[0] = PortalMaterial()

                // We also need to add a PortalComponent that targets the portalContentRoot
                portalSphere.components.set(PortalComponent(target: portalContentRoot))

//                let portalSphere2 = portalSphere.clone(recursive: true)
//                portalSphere2.position = SIMD3<Float>(-0.5, 1.4, -1)
//                rootEntity.addChild(portalSphere2)
//
//                let portalSphere3 = portalSphere.clone(recursive: true)
//                portalSphere3.position = SIMD3<Float>(0.5, 1.4, -1)
//                rootEntity.addChild(portalSphere3)

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
