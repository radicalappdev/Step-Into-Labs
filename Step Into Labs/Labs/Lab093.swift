//  Step Into Vision - Labs
//
//  Title: Lab093
//
//  Subtitle: Manipulation and Gestures fail with Portal Content
//
//  Description: When working with Entities inside a portal, Manipulation and Gestures do not work.
//
//  Type: Window
//
//  Created by Joseph Simpson on 10/27/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab093: View {

    @State var rootEntity = Entity()
    @State var portalEntity = ModelEntity(
        mesh: .generatePlane(width: 1.0, height: 1.0, cornerRadius: 0.03),
        materials: [PortalMaterial()]
    )

    var body: some View {
        GeometryReader3D { geometry in
            RealityView { content in
                content.add(rootEntity)

                let portalContentRoot = Entity()
                portalContentRoot.components.set(WorldComponent())
                rootEntity.addChild(portalContentRoot)
                portalEntity.position.z = -0.175
                portalEntity.components.set(PortalComponent(target: portalContentRoot))
                rootEntity.addChild(portalEntity)

                guard let scene = try? await Entity(named: "TeleportLabs", in: realityKitContentBundle) else { return }
                portalContentRoot.addChild(scene)
                scene.position.y = -1.4

                // Adding Manipulation to the Green Sphere
                if let subject = scene.findEntity(named: "StepSphereGreen") {
                    subject.components.set(ManipulationComponent())
                }


            } update: { content in
                // Resize the portal plane with the window
                let size = content.convert(geometry.size, from: .local, to: .scene)
                portalEntity.model?.mesh = .generatePlane(
                    width: size.x, height: size.y, cornerRadius: 0.03)
            }
        }
    }
}

#Preview {
    Lab093()
}
