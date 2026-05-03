//  Step Into Vision - Labs
//
//  Title: Lab102
//
//  Subtitle: Input works with Portals in Immersive Spaces
//
//  Description: A follow up to lab 093, where input when using portals in a window. The same lab input does work when using a portal in an immersive space.
//
//  Type: Space
//
//  Featured: true
//
//  Created by Joseph Simpson on 05/02/26.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab102: View {

    @State var rootEntity = Entity()
    @State var portalEntity = ModelEntity(
        mesh: .generatePlane(width: 1.0, height: 2.0, cornerRadius: 0.05),
        materials: [PortalMaterial()]
    )

    var body: some View {

        RealityView { content in
            content.add(rootEntity)

            let portalContentRoot = Entity()
            portalContentRoot.components.set(WorldComponent())
            rootEntity.addChild(portalContentRoot)
            portalEntity.position = .init(x: 0, y: 1, z: -2.1)
            portalEntity.components.set(PortalComponent(target: portalContentRoot))
            rootEntity.addChild(portalEntity)
            
            guard let scene = try? await Entity(named: "TeleportLabs", in: realityKitContentBundle) else { return }
            portalContentRoot.addChild(scene)
            
            // Adding Manipulation to the Green Sphere
            if let subject = scene.findEntity(named: "StepSphereGreen") {
                subject.components.set(ManipulationComponent())
            }

        }
    }
}

#Preview {
    Lab102()
}
