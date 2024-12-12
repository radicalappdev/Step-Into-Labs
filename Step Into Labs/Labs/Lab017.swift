//  Step Into Vision - Labs
//
//  Title: Lab017
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 12/11/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab017: View {

    @State var showSkyLarge: Bool = false

    var skyMat: ShaderGraphMaterial?
    var occMat: ShaderGraphMaterial?

    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "Lab017Scene", in: realityKitContentBundle) {
                content.add(scene)

                if let skySphere = content.entities.first?.findEntity(named: "SkySphere"), let occSphere = content.entities.first?.findEntity(named: "OccSphere") {

                    // Get their materials and save them in the vars.


                }



            }

        } update: {content, attachments in
            if let skySphere = content.entities.first?.findEntity(named: "SkySphere"), let occSphere = content.entities.first?.findEntity(named: "OccSphere") {

                // Disable this and replace it
                skySphere.scale = showSkyLarge ? [10, 10, 10] : [0.5, 0.5, 0.5]
                occSphere.scale = showSkyLarge ? [0.5, 0.5, 0.5] : [10, 10, 10]

                // Instead of scaling, swap the materials
            }


        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
        .gesture(tap)
        .modifier(DragGestureLab017())

    }

    var tap: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded {_ in
                showSkyLarge.toggle()
            }
    }
}

fileprivate struct DragGestureLab017: ViewModifier {

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
    Lab017()
}
