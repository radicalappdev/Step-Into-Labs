//  Step Into Vision - Labs
//
//  Title: Lab022
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 1/4/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab022: View {

    @State var session: SpatialTrackingSession?

    // The anchors we will use on the left hand
    @State var palmAnchor: Entity = AnchorEntity(.hand(.left, location: .palm))
    @State var indexAnchor: Entity = AnchorEntity(.hand(.left, location: .joint(for: .indexFingerTip)))
    @State var middleAnchor: Entity = AnchorEntity(.hand(.left, location: .joint(for: .middleFingerTip)))
    @State var ringAnchor: Entity = AnchorEntity(.hand(.left, location: .joint(for: .ringFingerTip)))
    @State var littleAnchor: Entity = AnchorEntity(.hand(.left, location: .joint(for: .littleFingerTip)))

    // Menu state
    @State var showMenu = false
    @State fileprivate var transformMode: IndirectTransformMode = .none

    var body: some View {
        RealityView { content, attachments in

            let configuration = SpatialTrackingSession.Configuration(
                tracking: [.hand])
            let session = SpatialTrackingSession()
            await session.run(configuration)


            // This scene has some content we can interact with later
            if let scene = try? await Entity(named: "HandMenuLabs", in: realityKitContentBundle) {
                content.add(scene)
            }

            // Add attachments to anchors
            if let palmMenu = attachments.entity(for: "PalmMenu") {
                palmAnchor.addChild(palmMenu)
                palmMenu.setPosition([0 ,0.025 ,0], relativeTo: palmAnchor)
                palmMenu.components.set(BillboardComponent())
                content.add(palmAnchor)
            }


            if let indexButton = attachments.entity(for: "nosign") {
                indexAnchor.addChild(indexButton)
                indexButton.setPosition([0.025, 0, 0], relativeTo: indexAnchor)
                indexButton.setScale([0.5 ,0.5 ,0.5], relativeTo: indexAnchor)
                indexButton.components.set(BillboardComponent())
                content.add(indexAnchor)
            }

            if let ringButton = attachments.entity(for: "move") {
                ringAnchor.addChild(ringButton)
                ringButton.setPosition([0.025, 0, 0], relativeTo: ringAnchor)
                ringButton.setScale([0.5 ,0.5 ,0.5], relativeTo: ringAnchor)
                ringButton.components.set(BillboardComponent())
                content.add(ringAnchor)
            }

            if let middleButton = attachments.entity(for: "rotate") {
                middleAnchor.addChild(middleButton)
                middleButton.setPosition([0.025, 0, 0], relativeTo: middleAnchor)
                middleButton.setScale([0.5 ,0.5 ,0.5], relativeTo: middleAnchor)
                middleButton.components.set(BillboardComponent())
                content.add(middleAnchor)
            }

            if let littleButton = attachments.entity(for: "scale") {
                littleAnchor.addChild(littleButton)
                littleButton.setPosition([0.025, 0, 0], relativeTo: littleAnchor)
                littleButton.setScale([0.5 ,0.5 ,0.5], relativeTo: littleAnchor)
                littleButton.components.set(BillboardComponent())
                content.add(littleAnchor)
            }




        } update: { content, attachments in



        } attachments: {
            Attachment(id: "PalmMenu") {
                Toggle(isOn: $showMenu.animation(), label: {
                    Image(systemName: showMenu ? "hand.raised.fill" : "hand.raised")
                })
                .toggleStyle(.button)
                .glassBackgroundEffect()
            }
            Attachment(id: "nosign") {
                Button {
                    transformMode = .none
                } label: {
                    Image(systemName: "nosign")
                }
                .foregroundStyle(transformMode == .none ? .blue : .white)
            }
            Attachment(id: "move") {
                Button {
                    transformMode = .move
                } label: {
                    Image(systemName: "move.3d")
                }
                .foregroundStyle(transformMode == .move ? .blue : .white)
            }
            Attachment(id: "rotate") {
                Button {
                    transformMode = .rotate
                } label: {
                    Image(systemName: "rotate.3d")
                }
                .foregroundStyle(transformMode == .rotate ? .blue : .white)
            }
            Attachment(id: "scale") {
                Button {
                    transformMode = .scale
                } label: {
                    Image(systemName: "scale.3d")
                }
                .foregroundStyle(transformMode == .scale ? .blue : .white)
            }
        }
        .persistentSystemOverlays(.hidden)
        .upperLimbVisibility(.hidden)
        .modifier(IndirectTransformGesture(mode: $transformMode))
    }
}

fileprivate enum IndirectTransformMode {
    case none
    case move
    case rotate
    case scale
}

fileprivate struct IndirectTransformGesture: ViewModifier {

    @Binding var mode: IndirectTransformMode

    @State var isDragging: Bool = false
    @State var initialPosition: SIMD3<Float> = .zero
    @State var initialScale: SIMD3<Float> = .init(repeating: 1.0)
    @State var initialOrientation:simd_quatf = simd_quatf(
        vector: .init(repeating: 0.0)
    )

    @State var rotation: Angle = .zero

    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture()
                    .targetedToAnyEntity()
                    .onChanged { value in

                        // We we start the gesture, cache the entity position
                        if !isDragging {
                            isDragging = true
                            initialPosition = value.entity.position
                            initialScale = value.entity.scale
                            initialOrientation = value.entity.transform.rotation
                        }

                        switch mode {
                        case .move:
                            // Calculate vector by which to move the entity
                            let movement = value.convert(value.gestureValue.translation3D, from: .local, to: .scene)
                            // Add the two vectors and clamp the result to keep the entity in the volume. Ignore the Y axis
                            let newPostion = initialPosition + movement
                            let limit: Float = 0.25
                            let posX = min(max(newPostion.x, -limit), limit)
                            let posZ = min(max(newPostion.z, -limit), limit)
                            value.entity.position.x = posX
                            value.entity.position.z = posZ

                        case .rotate:
                            // Just a hack to rotate by *something* from the drag gesture. I'm sure there is a better way.
                            rotation.degrees += 0.01 * (value.velocity.width)
                            let rotationTransform = Transform(yaw: Float(rotation.radians))

                            value.entity.transform.rotation = initialOrientation * rotationTransform.rotation
                        case .scale:

                            // A hack to get some value from the gesture that we can use to scale
                            let magnification = 0.01 * Float(value.gestureValue.translation3D.x)
                            let scaler = magnification + initialScale.x

                            // Clamp scale values for each axis independently
                            let minScale: Float = 0.25
                            let maxScale: Float = 3
                            let newScaler: Float = min(max(scaler, minScale), maxScale)

                            // Apply the clamped scale to the entity
                            value.entity.setScale(
                                .init(repeating: newScaler),
                                relativeTo: value.entity.parent!
                            )
                        case .none: break
                        }


                    }
                    .onEnded { value in
                        // Clean up when the gesture has ended
                        isDragging = false
                        initialPosition = .zero
                        initialScale = .init(repeating: 1.0)
                        initialOrientation = simd_quatf(
                            vector: .init(repeating: 0.0)
                        )
                    }
            )

    }
}
