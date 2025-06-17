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
                    HStack {
                        Text("X Position:")
                        Spacer()
                        Text("\(subject.observable.position.x)")
                    }

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
