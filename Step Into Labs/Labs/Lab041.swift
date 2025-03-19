//  Step Into Vision - Labs
//
//  Title: Lab041
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 3/19/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab041: View {

    @State var outerContent = Entity()
    @State var portalContent = Entity()

    @State var portalEntity = ModelEntity(
        mesh: .generatePlane(width: 0.8, height: 2, cornerRadius: 0.01),
        materials: [PortalMaterial()]
    )

    @State var occEntity = ModelEntity(
        mesh: .generatePlane(width: 0.8, height: 2, cornerRadius: 0.01),
        materials: [OcclusionMaterial()]
    )

    var body: some View {
        RealityView { content in
            guard let doorway = try? await Entity(named: "PortalDoorway", in: realityKitContentBundle) else { return }
            guard let sceneRed = try? await Entity(named: "PortalSwapRed", in: realityKitContentBundle) else { return }
            guard let sceneBlue = try? await Entity(named: "PortalSwapBlue", in: realityKitContentBundle) else { return }

            // 1. The root for our scene, which will always include the portals, occlusion, and doorway
            let rootEntity = Entity()

            content.add(rootEntity)
            rootEntity.addChild(doorway)

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
            portalEntity.position = [0, 1, -0.99]
            // We need to add a PortalComponent that targets the portalContent
            portalEntity.components.set(PortalComponent(target: portalContent))
            // Set up some components to make the portal interactive
            let portalCollision = CollisionComponent(shapes: [.generateBox(width: 0.5, height: 0.8, depth: 0.05)])
            portalEntity.components.set(portalCollision)
            portalEntity.components.set(InputTargetComponent())
            rootEntity.addChild(portalEntity)

            occEntity.position = [0, 1, -1.01]
            occEntity.transform.rotation = simd_quatf(angle: .pi , axis: [0, 1, 0])
            let occCollision = CollisionComponent(shapes: [.generateBox(width: 0.5, height: 0.8, depth: 0.05)])
            occEntity.components.set(portalCollision)
            occEntity.components.set(InputTargetComponent())

            rootEntity.addChild(occEntity)

        }
        .gesture(doubleTap)
        .modifier(DragGestureImproved())
    }

    var doubleTap: some Gesture {
        TapGesture(count: 2)
            .targetedToAnyEntity()
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
    Lab041()
}
