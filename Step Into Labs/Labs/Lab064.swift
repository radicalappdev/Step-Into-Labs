//  Step Into Vision - Labs
//
//  Title: Lab064
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 6/18/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab064: View {

    @State private var subject = Entity()
    @State private var showingPopover: Bool = false

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "ObserveEntity", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.position.y = -0.4

            guard let subject = scene.findEntity(named: "ToyRocket") else { return }

            self.subject = subject

            // Create a gesture
            let tapGesture = TapGesture()
                .onEnded({
                    // Bonus: we'll use a SwiftUI animation to scale the entity
                    Entity.animate(.bouncy, body: {
                        showingPopover.toggle()
                    })
                })

            // Pass the gestutre to GestureComponent
            let gestureComponent = GestureComponent(tapGesture)

            let presentation = PresentationComponent(
                isPresented: $showingPopover,
                configuration: .popover(arrowEdge: .bottom),
                content: RocketCard()
            )

            subject.components.set(presentation)
            subject.components.set(gestureComponent)

        }

    }
}

#Preview {
    Lab064()
}


fileprivate struct RocketCard: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("Rocket")
                .font(.largeTitle)

            Text("🚀🚀🚀🚀🚀")
                .font(.largeTitle)
        }
        .foregroundStyle(.black)
        .textCase(.uppercase)
        .padding()
    }
}
