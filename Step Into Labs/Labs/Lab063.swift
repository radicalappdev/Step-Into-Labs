//  Step Into Vision - Labs
//
//  Title: Lab063
//
//  Subtitle: First look at Entity Observation
//
//  Description: SwiftUI can now observe changes directly from RealityKit entities.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 6/17/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab063: View {

    @State private var subject: Entity?

    @State private var subjectTransform: Transform = .init()

    @State var willBegin: EventSubscription?
    @State var willEnd: EventSubscription?

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "ObserveEntity", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.position.y = -0.4

            // Load the subject entity and add the ManipulationComponent so we can interact with it
            guard let subject = scene.findEntity(named: "ToyRocket") else { return }
            subject.components.set(ManipulationComponent())

            // We'll only observe the subject while the Manipulation is active
            willBegin = content.subscribe(to: ManipulationEvents.WillBegin.self) { event in
                withAnimation {
                    self.subject = event.entity

                }
            }

            willEnd = content.subscribe(to: ManipulationEvents.WillEnd.self) { event in
                withAnimation {

                    self.subject = nil
                }
            }

        }
        .onChange(of: subject?.observable.transform) {
            // Do something when the value changes
            // Update related views
            // Apply side effects (clamping or transforming values, etc)
            print("Subject Transform Changed \(String(describing: subject?.observable.transform))")
        }
        .ornament(attachmentAnchor: .scene(.back), ornament: {
            List {
                Section("Observed Entity Data", content: {

                    if let subject = self.subject {
                        VectorDisplay(title: "Position", vector: subject.observable.position)

                        VStack(alignment: .leading) {
                            Text("Rotation \(subject.observable.orientation.angle)")
                                .fontWeight(.bold)
                            VectorDisplay(title: "", vector: subject.observable.orientation.axis)
                        }

                        VectorDisplay(title: "Scale", vector: subject.observable.scale)

                    }

                })
            }
            .padding(.top, 12)
            .frame(width: 460, height: 500)
            .glassBackgroundEffect()
            .offset(y: subject != nil ? 0: 500)
            .opacity(subject != nil ? 1 : 0)
        })
    }
}

#Preview("Volume", windowStyle: .volumetric) {
    Lab063()
}


fileprivate struct VectorDisplay: View {
    let title: String
    let vector: SIMD3<Float>

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .fontWeight(.bold)
            HStack {
                ForEach(["X", "Y", "Z"], id: \.self) { axis in
                    let value = axis == "X" ? vector.x : axis == "Y" ? vector.y : vector.z
                    Text("\(axis): \(String(format: "%8.3f", value.isNaN ? 0 : value))")
                        .frame(width: 120, alignment: .leading)
                }
            }
        }
    }
}
