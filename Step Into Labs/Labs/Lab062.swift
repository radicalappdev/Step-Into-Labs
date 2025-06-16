//  Step Into Vision - Labs
//
//  Title: Lab062
//
//  Subtitle: First look at Gesture Component
//
//  Description: A component that allows us to create unique SwiftUI gestures for RealityKit entities.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 6/16/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab062: View {

    @State private var subjectToggle = false

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "SwiftUIAnimationLab", in: realityKitContentBundle) else { return }
            content.add(scene)

            // Load the subject entity
            guard let subject = scene.findEntity(named: "Subject") else { return }

            // Create a gesture
            let tapGesture = TapGesture()
                .onEnded({
                    // Bonus: we'll use a SwiftUI animation to scale the entity
                    Entity.animate(.bouncy, body: {
                        subjectToggle.toggle()
                        let scaler: Float = subjectToggle ? 2.0 : 1.0
                        subject.scale = .init(repeating: scaler)
                    })
                })

            // Pass the gestutre to GestureComponent
            let gestureComponent = GestureComponent(tapGesture)

            // Add GestureComponent to the entity
            subject.components.set(gestureComponent)

        }
    }
}

#Preview {
    Lab062()
}
