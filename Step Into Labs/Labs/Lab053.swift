//  Step Into Vision - Labs
//
//  Title: Lab053
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 5/22/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab053: View {
    var body: some View {
        RealityView { content, attachments in

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
            portalEntity.position.z = -0.175

            // We also need to add a PortalComponent that targets the portalContentRoot
            portalEntity.components.set(PortalComponent(target: portalContentRoot))
            rootEntity.addChild(portalEntity)


            // 4. We'll load some content to add to the portalContentRoot
            guard let scene = try? await Entity(named: "NoFloor", in: realityKitContentBundle) else { return }

            //  add an attachment as a child of an entity
            if let wetFloorSign = scene.findEntity(named: "wet_floor_sign"),
               let wetFloorAttachment = attachments.entity(for: "wet_floor_attachment") {
                // The wet_floor_sign asset was converted from another format. It was scaled to 0.01 on all axes to fit in this scene.
                // We'll have to scale the attachment to compensate for the scale of the entity

                // Add the wetFloorAttachment attachment as a child of the wet floor sign
                wetFloorSign.addChild(wetFloorAttachment)

                // Adjust the transform to position it just in front of the sign
                let transform = Transform(scale: .init(repeating: 200), rotation: simd_quatf(Rotation3D(angle: Angle2D(degrees: 11), axis: RotationAxis3D(x: -1, y: 0, z: 0))), translation: [0, 30, 6.7])
                wetFloorAttachment.transform = transform
            }

            // use an entity to position the attachment. Add the attachment to the scene content
            if let trafficCone = scene.findEntity(named: "traffic_cone_02"),
               let traffiConeAttachment = attachments.entity(for: "traffic_cone_attachment") {

                // For this example, we'll add the attachment directly to the scenc content
                scene.addChild(traffiConeAttachment)

                // Then we'll use the data from the traffic cone entity to determine the transform for the attachment
                let transform = Transform(
                    scale: .init(repeating: 1.0),
                    rotation: simd_quatf(
                        Rotation3D(angle: Angle2D(degrees: -24), axis: RotationAxis3D(x: 0, y: 1, z: 0))
                    ),
                    translation: trafficCone.position + [0, 0.8 , 0]
                )

                traffiConeAttachment.transform = transform
            }

            portalContentRoot.addChild(scene)
            scene.position.y = -1.4

        } update: { content, attachments in

        } attachments: {


            Attachment(id: "wet_floor_attachment") {
                VStack(spacing: 24) {
                    Text("CAUTION")
                        .font(.largeTitle)
                    ZStack {
                        Image(systemName: "triangle")
                            .font(.system(size: 96, weight: .semibold))
                        Image(systemName: "figure.fall")
                            .font(.system(size: 42, weight: .heavy))
                            .offset(y:12)
                    }
                    Text("No Floor")
                        .font(.largeTitle)
                }
                .foregroundStyle(.black)
                .textCase(.uppercase)
                .padding()
            }

            Attachment(id: "traffic_cone_attachment") {
                VStack(spacing: 24) {
                    Text("Attachments Render")
                        .font(.extraLargeTitle)
                    ZStack {
                        Image(systemName: "triangle")
                            .font(.system(size: 96, weight: .semibold))
                        Image(systemName: "eyes")
                            .font(.system(size: 36, weight: .heavy))
                            .offset(y:12)
                    }
                    .onTapGesture {
                        print("does this do anything?")
                    }
                    .hoverEffect()
                    Text("but are not interactive")
                        .font(.extraLargeTitle)
                }
                .padding(24)
                .foregroundStyle(.white)
                .textCase(.uppercase)
                .background(.trafficOrange)
                .clipShape(.rect(cornerRadius: 24.0))
            }

        }
    }
}

#Preview {
    Lab053()
}
