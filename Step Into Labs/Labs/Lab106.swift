//  Step Into Vision - Labs
//
//  Title: Lab106
//
//  Subtitle: Mist
//
//  Description: I'm using this lab to build a basic scene that will be used for some other ideas later.
//
//  Type: Space
//
//  Featured: true
//
//  Created by Joseph Simpson on 5/7/26.
//  boat_ornament by The Base Mesh [CC0]
//  sundial by The Base Mesh [CC0]
//  crt_monitor by The Base Mesh [CC0]
//  retro_computer by The Base Mesh [CC0]

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab106: View {
    var body: some View {
        RealityView { content in

            guard let rootEntity = try? await Entity(named: "Mist", in: realityKitContentBundle) else { return }
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
                        crossingMode: .disabled
                    ))
                }
            }

            // 4. We'll load some content to add to the portalContentRoot
            guard let scene = try? await Entity(named: "Droplet", in: realityKitContentBundle) else { return }
            scene.scale = .init(repeating: 0.5)
            scene.position = [0, 4, -9]
            scene.orientation = simd_quatf(angle: -6, axis: [1, 0, 0])
            portalContentRoot.addChild(scene)


        }
    }
}

#Preview {
    Lab106()
}
