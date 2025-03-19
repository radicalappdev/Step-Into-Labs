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
    @State var portalContentFront = Entity()
    @State var portalContentBack = Entity()

    @State var portalEntityFront = ModelEntity(
        mesh: .generatePlane(width: 0.8, height: 2, cornerRadius: 0.01),
        materials: [PortalMaterial()]
    )

    @State var portalEntityBack = ModelEntity(
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

            let rootEntity = Entity()
            content.add(rootEntity)

            rootEntity.addChild(doorway)
            rootEntity.addChild(outerContent)
            rootEntity.addChild(portalContentFront)
            rootEntity.addChild(portalContentBack)
            rootEntity.addChild(occEntity)



            // Front portal
            portalContentFront.addChild(sceneRed)
            portalContentFront.components.set(WorldComponent())

            portalEntityFront.position = [-1.2, 1, -0.99]
            portalEntityFront.components.set(PortalComponent(target: portalContentFront))

            let portalCollisionFront = CollisionComponent(shapes: [.generateBox(width: 0.5, height: 0.8, depth: 0.05)])
            portalEntityFront.components.set(portalCollisionFront)
            portalEntityFront.components.set(InputTargetComponent())
            rootEntity.addChild(portalEntityFront)

            // Back portal
            portalContentBack.addChild(sceneBlue)
            portalContentBack.components.set(WorldComponent())

            portalEntityBack.position = [1.2, 1, -0.99]
            portalEntityBack.components.set(PortalComponent(target: portalContentBack))

            let portalCollisionBack = CollisionComponent(shapes: [.generateBox(width: 0.5, height: 0.8, depth: 0.05)])
            portalEntityBack.components.set(portalCollisionBack)
            portalEntityBack.components.set(InputTargetComponent())
            rootEntity.addChild(portalEntityBack)



            occEntity.position = [0, 1, -1.01]
//            occEntity.transform.rotation = simd_quatf(angle: .pi , axis: [0, 1, 0])
            let occCollision = CollisionComponent(shapes: [.generateBox(width: 0.5, height: 0.8, depth: 0.05)])
            occEntity.components.set(occCollision)
            occEntity.components.set(InputTargetComponent())


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
                   let portalContentFirstChild = portalContentFront.children.first {

                    outerContent.removeChild(outerContentFirstChild)
                    portalContentFront.removeChild(portalContentFirstChild)

                    outerContent.addChild(portalContentFirstChild)
                    portalContentFront.addChild(outerContentFirstChild)
                }


            }
    }
}

#Preview {
    Lab041()
}
