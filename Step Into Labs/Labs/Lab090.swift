//  Step Into Vision - Labs
//
//  Title: Lab090
//
//  Subtitle: Manipulation & Tap Workaround
//
//  Description: We can't use Gestures and Mnipulation at the same time, but we can use this workaround.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 10/16/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab090: View {

    @State private var showingPopover: Bool = false
    @State private var manipulationStart: SIMD3<Float> = .zero
    @State private var manipulationMaxDistanceSquared: Float = .zero

    @State private var willBegin: EventSubscription?
    @State private var didUpdateTransform: EventSubscription?
    @State private var willEnd: EventSubscription?

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "ObserveEntity", in: realityKitContentBundle) else { return }
            scene.position.y = -0.4
            content.add(scene)


            guard let subject = scene.findEntity(named: "ToyRocket") else { return }

            if let present = subject.findEntity(named: "Present") {
                // Add a popover
                let presentation = PresentationComponent(
                    isPresented: $showingPopover,
                    configuration: .popover(arrowEdge: .bottom),
                    content: RocketCard()
                )
                present.components.set(presentation)
            }


            // Set up Manipulation. The entity already has collision and input components
            let mc = ManipulationComponent()
            subject.components.set(mc)

            // Capture the entity starting position
            willBegin = content.subscribe(to: ManipulationEvents.WillBegin.self) { event in
                manipulationStart = event.entity.position
                manipulationMaxDistanceSquared = .zero
            }

            // Write the distance between this update and the start position
            didUpdateTransform = content.subscribe(to: ManipulationEvents.DidUpdateTransform.self) { event in
                let distanceSquared = simd_distance_squared(manipulationStart, event.entity.position)
                if manipulationMaxDistanceSquared < distanceSquared {
                    manipulationMaxDistanceSquared = distanceSquared
                }

            }

            // Check to see if the distance falls below a threshold
            willEnd = content.subscribe(to: ManipulationEvents.WillEnd.self)  { event in
                if(manipulationMaxDistanceSquared < 0.01 * 0.01) {
                    print("tapped registered")
                    showingPopover.toggle()
                } else {
                    print("manipulation registered")
                }

            }

        }
        .onDisappear() {
            willBegin?.cancel()
            didUpdateTransform?.cancel()
            willEnd?.cancel()
        }
    }
}

#Preview {
    Lab090()
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
