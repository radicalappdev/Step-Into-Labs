//  Step Into Vision - Labs
//
//  Title: Lab040
//
//  Subtitle: Portal Swap
//
//  Description: Using a portal to switch between two worlds.
//
//  Type: Space
//
//  Created by Joseph Simpson on 3/14/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab040: View {

    @State var outerContent = Entity()
    @State var portalContent = Entity()

    @State var portalEntity = ModelEntity(
        mesh: .generatePlane(width: 0.5, height: 0.8, cornerRadius: 0.1),
        materials: [PortalMaterial()]
    )

    var body: some View {
        RealityView { content in
            guard let sceneRed = try? await Entity(named: "PortalSwapRed", in: realityKitContentBundle) else { return }
            guard let sceneBlue = try? await Entity(named: "PortalSwapBlue", in: realityKitContentBundle) else { return }

            // 1. The root for our scene, which will always include the portal entity
            let rootEntity = Entity()
            content.add(rootEntity)

            // 2. The content that will display *outside* of the portal
            // This includes everything *except* the portal entity itself.
            rootEntity.addChild(outerContent)
            outerContent.addChild(sceneRed)

            // 3. The  content that will appear *inside* the portal
            // We need a WorldComponent here
            portalContent.addChild(sceneBlue)
            portalContent.components.set(WorldComponent())
            rootEntity.addChild(portalContent)

            // 4. An entity that will render the portal (created above as state)
            portalEntity.position = [0, 1.4, -1]
            // We need to add a PortalComponent that targets the portalContent
            portalEntity.components.set(PortalComponent(target: portalContent))
            // Set up some components to make the portal interactive
            let collision = CollisionComponent(shapes: [.generateBox(width: 0.5, height: 0.8, depth: 0.05)])
            portalEntity.components.set(collision)
            portalEntity.components.set(InputTargetComponent())
            portalEntity.components.set(BillboardComponent())
            rootEntity.addChild(portalEntity)

        }
        .gesture(doubleTap)
        .modifier(DragGestureImproved())
    }

    var doubleTap: some Gesture {
        TapGesture(count: 2)
            .targetedToEntity(portalEntity)
            .onEnded { value in

                // Swap the outer and portal content
                if let outerContentFirstChild = outerContent.children.first,
                   let portalContentFirstChild = portalContent.children.first {

                    outerContent.removeChild(outerContentFirstChild)
                    portalContent.removeChild(portalContentFirstChild)

                    outerContent.addChild(portalContentFirstChild)
                    portalContent.addChild(outerContentFirstChild)
                }


            }
    }
}

#Preview {
    Lab040()
}
