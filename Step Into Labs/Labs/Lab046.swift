//  Step Into Vision - Labs
//
//  Title: Lab046
//
//  Subtitle: Portals can do what?
//
//  Description: I'm not sure what to do with this information.
//
//  Type: Window
//
//  Created by Joseph Simpson on 4/9/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab046: View {

    @State var opacity: Float = 1.0

    var body: some View {
        RealityView { content in

            // Portal example from Lab 037

            // 1. The root for our scene *outside* of the portal
            let rootEntity = Entity()
            content.add(rootEntity)

            // 2. The root for the content that will appear *inside* the portal
            // We need a WorldComponent here
            let portalContentRoot = Entity()
            portalContentRoot.components.set(WorldComponent())
            rootEntity.addChild(portalContentRoot)

            // 3. An entity that will render the portal
            // We need to use PortalMaterial
            let portalEntity = ModelEntity(
                mesh: .generatePlane(width: 0.4, height: 0.2, cornerRadius: 0.03),
                materials: [PortalMaterial()]
            )
            portalEntity.name = "Portal"
            portalEntity.position.z = -0.175

            // We also need to add a PortalComponent that targets the portalContentRoot
            portalEntity.components.set(PortalComponent(target: portalContentRoot))
            rootEntity.addChild(portalEntity)


            // 4. We'll load some content to add to the portalContentRoot
            guard let scene = try? await Entity(named: "TeleportLabs", in: realityKitContentBundle) else { return }

            portalContentRoot.addChild(scene)
            scene.position.y = -1.4

        } update: { content in
            // Note: this is not an ideal way to adjust opacity, but it works as a quick hack
            if let portalEntity = content.entities.first?.findEntity(named: "Portal") {

                Task {
                    let action = FromToByAction<Float>(to: opacity,
                                                       timing: .linear,
                                                       isAdditive: false
                    )

                    let animation = try! AnimationResource.makeActionAnimation(for: action,
                                                                               duration: 0.1,
                                                                               bindTarget: .opacity,
                    )
                    portalEntity.playAnimation(animation)
                }
            }

        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                Slider(value: $opacity,
                       in: 0.0...1.0,
                       step: 0.1,
                       minimumValueLabel: Image(systemName: "circle.dotted"),
                       maximumValueLabel: Image(systemName: "circle.fill"),

                       label: {
                            Text("Opacity")
                        })
                .frame(width: 300)
            })
        }
    }
}

#Preview {
    Lab046()
}
