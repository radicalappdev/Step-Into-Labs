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

                        // We we start the gesture, cache the entity position
                        if !isDragging {
                            isDragging = true
                            initialPosition = value.entity.position
                        }

                        // Calculate vector by which to move the entity
                        let movement = value.convert(value.gestureValue.translation3D, from: .local, to: .scene)

                        // only allow movement on the y axis

                        // Add the initial position and the movement to get the new position
                        value.entity.position = initialPosition + movement

                    }
                    .onEnded { value in
                        // Clean up when the gesture has ended
                        isDragging = false
                        initialPosition = .zero
                    }
            )

    }
}

#Preview {
    Lab018()
}
