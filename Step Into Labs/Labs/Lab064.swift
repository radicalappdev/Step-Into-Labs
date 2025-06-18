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

            guard let scene = try? await Entity(named: "PresentationComponentLab", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.position.y = -0.4

            // The main entity we are looking at
            guard let subject = scene.findEntity(named: "ToyRocket") else { return }
            self.subject = subject

            // A secondary entity that we can use as the transform point for the presented popover
            guard let presentationPoint = scene.findEntity(named: "PresentationPoint") else { return }

            // We'll use a TapGesture and the new GestureComponent to toggle the popover
            let tapGesture = TapGesture()
                .onEnded({
                    Entity.animate(.bouncy, body: {
                        showingPopover.toggle()
                    })
                })
            let gestureComponent = GestureComponent(tapGesture)
            subject.components.set(gestureComponent)

            // Create the presentation component using $showingPopover to toggle presentation
            let presentation = PresentationComponent(
                isPresented: $showingPopover,
                configuration: .popover(arrowEdge: .bottom),
                content: RocketCard()
            )
            presentationPoint.components.set(presentation)

        }

    }
}

#Preview("Volume", windowStyle: .volumetric) {
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
