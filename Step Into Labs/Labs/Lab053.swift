//  Step Into Vision - Labs
//
//  Title: Lab053
//
//  Subtitle: Using Attachments in Portals
//
//  Description: We can render SwiftUI views as attachments inside portals, but they are not interactive.
//
//  Type: Window
//
//  Created by Joseph Simpson on 5/22/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab053: View {

    // The root for our scene *outside* of the portal
    @State var rootEntity = Entity()

    // An entity that will render the portal
    @State var portalEntity = ModelEntity(
        mesh: .generatePlane(width: 1.0, height: 1.0),
        materials: [PortalMaterial()]
    )

    var body: some View {
        GeometryReader3D { geometry in
            ZStack {
                RealityView { content, attachments in
                    content.add(rootEntity)

                    // The root for the content that will appear *inside* the portal
                    let portalContentRoot = Entity()
                    portalContentRoot.components.set(WorldComponent())
                    rootEntity.addChild(portalContentRoot)
                    portalEntity.components.set(PortalComponent(target: portalContentRoot))
                    rootEntity.addChild(portalEntity)


                    // We'll load some content to add to the portalContentRoot
                    guard let scene = try? await Entity(named: "NoFloor", in: realityKitContentBundle) else { return }

                    if let wetFloorSign = scene.findEntity(named: "wet_floor_sign"),
                       let wetFloorAttachment = attachments.entity(for: "wet_floor_attachment") {
                        wetFloorSign.addChild(wetFloorAttachment)
                        let transform = Transform(scale: .init(repeating: 200), rotation: simd_quatf(Rotation3D(angle: Angle2D(degrees: 11), axis: RotationAxis3D(x: -1, y: 0, z: 0))), translation: [0, 30, 6.7])
                        wetFloorAttachment.transform = transform
                    }

                    if let trafficCone = scene.findEntity(named: "traffic_cone_02"),
                       let traffiConeAttachment = attachments.entity(for: "traffic_cone_attachment") {
                        scene.addChild(traffiConeAttachment)
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

                    // Resize the scene based on the size of the reality view content.
                    // Based on the example from Apple https://developer.apple.com/documentation/visionos/displaying-a-3d-environment-through-a-portal
                    let size = content.convert(geometry.size, from: .local, to: .scene)

                    portalEntity.model?.mesh = .generatePlane(
                        width: size.x, height: size.y, cornerRadius: 0.03)

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
                            .symbolEffect(.bounce)
                            .onTapGesture {
                                print("does this do anything?")
                            }
                            .hoverEffect()
                            Text("No Ground")
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
                            .symbolEffect(.breathe)
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
                // Size and align the Reality View to sit flush against the window
                .frame(depth: 1)
                .frame(maxDepth: .infinity, alignment: .back)
            }
        }
    }
}

#Preview {
    Lab053()
}
