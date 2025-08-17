//  Step Into Vision - Labs
//
//  Title: Lab077
//
//  Subtitle: Ornaments in Presentations?
//
//  Description: We *can* add ornaments to popovers shown by PresentationComponent, but I'm not sure if we *should*.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 8/17/25.

import SwiftUI
import RealityKit
import RealityKitContent

// This lab extends Lab 064 to add ornaments to the view inside the popover.
struct Lab077: View {
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
                content: RocketCard(title: "PresentationComponent showing a Popover")
            )
            presentationPoint.components.set(presentation)
        }
    }
}

#Preview {
    Lab077()
}


fileprivate struct RocketCard: View {
    var title: String = "Rocket"
    var body: some View {
        VStack {

            VStack(spacing: 24) {
                Text(title)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                Text("🚀")
                    .font(.largeTitle)
            }
            .frame(width: 200, height: 220)
            .padding()
            .ornament(attachmentAnchor: .parent(.top), ornament: {
                HStack {
                    Text("Top Ornament")
                }
                .padding()
                .glassBackgroundEffect()
            })
            .ornament(attachmentAnchor: .parent(.leading), ornament: {
                HStack {
                    Text("🚀")
                }
                .padding()
                .glassBackgroundEffect()
            })
            .ornament(attachmentAnchor: .parent(.trailing), ornament: {
                HStack {
                    Text("🚀")
                }
                .padding()
                .glassBackgroundEffect()
            })
        }
    }
}
