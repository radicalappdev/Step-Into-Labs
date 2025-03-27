//  Step Into Vision - Labs
//
//  Title: Lab044
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 3/27/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab044: View {
    var body: some View {
        RealityView { content, attachments in

            guard let scene = try? await Entity(named: "InputOddness", in: realityKitContentBundle)  else { return }

            content.add(scene)

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
        .modifier(DragGestureExample())
    }


}


fileprivate struct DragGestureExample: ViewModifier {

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
    Lab044()
}
