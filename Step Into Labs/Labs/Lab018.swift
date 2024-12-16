//  Step Into Vision - Labs
//
//  Title: Lab018
//
//  Subtitle: Pulling an entity out the ground
//
//  Description: Using occlusion material to hide an entity under the users ground or floor.
//
//  Type: Space
//
//  Created by Joseph Simpson on 12/16/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab018: View {
    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "Lab018Scene", in: realityKitContentBundle) {
                content.add(scene)
            }

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
        .modifier(DragGestureLab018())
    }
}

fileprivate struct DragGestureLab018: ViewModifier {

    @State var isDragging: Bool = false
    @State var initialPosition: SIMD3<Float> = .zero

    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture()
                    .targetedToAnyEntity()
                    .onChanged { value in

                        if !isDragging {
                            isDragging = true
                            initialPosition = value.entity.position
                        }

                        let movement = value.convert(value.gestureValue.translation3D, from: .local, to: .scene)
                        let yOnlyMovement = SIMD3<Float>(0, movement.y, 0)
                        value.entity.position = initialPosition + yOnlyMovement

                    }
                    .onEnded { value in
                        isDragging = false
                        initialPosition = .zero
                    }
            )

    }
}

#Preview {
    Lab018()
}
