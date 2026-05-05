//  Step Into Vision - Labs
//
//  Title: Lab104
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Featured:
//
//  Created by Joseph Simpson on 5/5/26.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab104: View {

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

            guard let portalGlass = try? await Entity(named: "PortalGlass", in: realityKitContentBundle) else { return }
            rootEntity.addChild(portalGlass)

            // 3. We need something to render the portal on
            print("✅scene found")



            if let lens = portalGlass.findEntity(named: "Lens") {
                print("✅lens found")

                // Replace the material with PortalMaterial
                lens.components[ModelComponent.self]?.materials[0] = PortalMaterial()

                // We also need to add a PortalComponent that targets the portalContentRoot
                lens.components.set(PortalComponent(target: portalContentRoot))
            }

            // 4. We'll load some content to add to the portalContentRoot
            guard let scene = try? await Entity(named: "TeleportLabs", in: realityKitContentBundle) else { return }
            portalContentRoot.addChild(scene)

        }
    }
}

#Preview {
    Lab104()
}
