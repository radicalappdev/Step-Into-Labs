//  Step Into Vision - Labs
//
//  Title: Lab063
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 6/17/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab063: View {

    @State private var subject = Entity()

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "ObserveEntity", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.position.y = -0.4

            // Load the subject entity
            guard let subject = scene.findEntity(named: "ToyRocket") else { return }
            subject.components.set(ManipulationComponent())
            self.subject = subject



        }
        .onChange(of: subject.observable.position) {
            print("New subject \(subject.observable.position)")
        }
        .ornament(attachmentAnchor: .scene(.back), ornament: {
            List {
                Section("Observed Entity Data", content: {

                    VectorDisplay(title: "Position", vector: subject.observable.position)

                    VStack(alignment: .leading) {
                        Text("Rotation \(subject.observable.orientation.angle)")
                            .fontWeight(.bold)
                        VectorDisplay(title: "", vector: subject.observable.orientation.axis)
                    }

                    VectorDisplay(title: "Scale", vector: subject.observable.scale)
                })
            }
            .padding(.top, 12)
            .frame(width: 460, height: 500)
            .glassBackgroundEffect()

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
                    Text("\(axis): \(String(format: "%8.3f", axis == "X" ? vector.x : axis == "Y" ? vector.y : vector.z))")
                        .frame(width: 120, alignment: .leading)
                }
            }
        }
    }
}
