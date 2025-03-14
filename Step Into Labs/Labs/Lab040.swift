//  Step Into Vision - Labs
//
//  Title: Lab040
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 3/14/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab040: View {

    @State var outerContent = Entity()
    @State var portalContentRoot = Entity()
    @State var portalContentRed: Entity?
    @State var portalContentBlue: Entity?

    @State var portalEntity = ModelEntity(
        mesh: .generatePlane(width: 0.5, height: 0.8, cornerRadius: 0.3),
        materials: [PortalMaterial()]
    )

    var body: some View {
        RealityView { content in
            guard let sceneRed = try? await Entity(named: "PortalSwapRed", in: realityKitContentBundle) else { return }
            guard let sceneBlue = try? await Entity(named: "PortalSwapBlue", in: realityKitContentBundle) else { return }
            portalContentRed = sceneRed
            portalContentBlue = sceneBlue


            // 1. The root for our scene *outside* of the portal
            let rootEntity = Entity()
            content.add(rootEntity)
            rootEntity.addChild(outerContent)
            outerContent.addChild(sceneRed)


            // 2. The root for the content that will appear *inside* the portal
            // We need a WorldComponent here
            portalContentRoot.components.set(WorldComponent())
            rootEntity.addChild(portalContentRoot)

            // 3. An entity that will render the portal
            portalEntity.position = [0, 1.4, -1]
            let collision = CollisionComponent(shapes: [.generateBox(width: 0.5, height: 0.8, depth: 0.05)])
            portalEntity.components.set(collision)
            portalEntity.components.set(InputTargetComponent())

            // We also need to add a PortalComponent that targets the portalContentRoot
            portalEntity.components.set(PortalComponent(target: portalContentRoot))
            rootEntity.addChild(portalEntity)


            // 4. We'll load some content to add to the portalContentRoot

            portalContentRoot.addChild(sceneBlue)

        }
        .gesture(doubleTap)
    }

    var doubleTap: some Gesture {
        TapGesture(count: 2)
            .targetedToEntity(portalEntity)
            .onEnded { value in
                print("double tap")
            }
    }
}

#Preview {
    Lab040()
}
