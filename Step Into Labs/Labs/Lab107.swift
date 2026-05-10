//  Step Into Vision - Labs
//
//  Title: Lab107
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Featured:
//
//  Created by Joseph Simpson on 5/10/26.
//  duck_sculpture by The Base Mesh [CC0]
//  teapot by The Base Mesh [CC0]

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab107: View {
    var body: some View {
        RealityView { content in

            guard let rootEntity = try? await Entity(named: "Droplet", in: realityKitContentBundle) else { return }
            content.add(rootEntity)

            // 2. The root for the content that will appear *inside* the portal
            // We need a WorldComponent here
            let portalContentRoot = Entity()
            portalContentRoot.components.set(WorldComponent())
            rootEntity.addChild(portalContentRoot)

            // 3. We need something to render the portal on
            if let screenSurface = rootEntity.findEntity(named: "ScreenSurface") {
                var portalMaterial = PortalMaterial()
                portalMaterial.faceCulling = .none

                if var modelComponent = screenSurface.components[ModelComponent.self] {
                    modelComponent.materials = modelComponent.materials.map { _ in portalMaterial }
                    screenSurface.components.set(modelComponent)

                    screenSurface.components.set(PortalComponent(
                        target: portalContentRoot,
                        clippingMode: .plane(.negativeY),
                        crossingMode: .plane(.negativeY)
                    ))
                }
            }

            // 4. We'll load some content to add to the portalContentRoot
            guard let scene = try? await Entity(named: "DropletInner", in: realityKitContentBundle) else { return }
            scene.components.set(PortalCrossingComponent())
            portalContentRoot.addChild(scene)

        }
    }}

#Preview {
    Lab107()
}
