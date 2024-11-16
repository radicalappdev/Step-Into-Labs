//  Step Into Vision - Labs
//
//  Title: Lab014
//
//  Subtitle: Building an Indirect Transform System
//
//  Description: Use the Drag Gesture and a Toolbar to switch modes. We can use one gesture to drag, scale, and rotate our entities.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 11/16/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab014: View {

    @State fileprivate var transformMode: IndirectTransformMode = .none

    var body: some View {
        RealityView { content in
            // Load the scene from the Reality Kit bundle
            if let scene = try? await Entity(named: "GestureLabs", in: realityKitContentBundle) {
                content.add(scene)

                // Lower the entire scene to the bottom of the volume
                scene.position.y = -0.4

                if let car = scene.findEntity(named: "ToyCar"), let plane = scene.findEntity(named: "ToyBiplane") {

                    car.removeFromParent()
                    plane.removeFromParent()

                }
            }
        }
        .modifier(IndirectTransformGesture(mode: $transformMode))
        .toolbar {
            // .bottomOrnament seems to be the only placement that works
            ToolbarItemGroup(placement: .bottomOrnament) {

                Button {
                    transformMode = .none
                } label: {
                    Image(systemName: "nosign")
                }
                .foregroundStyle(transformMode == .none ? .blue : .white)
                Button {
                    transformMode = .move
                } label: {
                    Image(systemName: "move.3d")
                }
                .foregroundStyle(transformMode == .move ? .blue : .white)
                Button {
                    transformMode = .rotate
                } label: {
                    Image(systemName: "rotate.3d")
                }
                .foregroundStyle(transformMode == .rotate ? .blue : .white)
                Button {
                    transformMode = .scale
                } label: {
                    Image(systemName: "scale.3d")
                }
                .foregroundStyle(transformMode == .scale ? .blue : .white)
            }

        }
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

                        case .rotate: break
                        case .scale: break
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

//#Preview {
//    Lab014()
//}
