//  Step Into Vision - Labs
//
//  Title: Lab079
//
//  Subtitle: Using Physics with Manipulation Component
//
//  Description: This labs explores how the new Manipulation Component works with physics bodies.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 8/25/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab079: View {

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "ManipulatePhysics", in: realityKitContentBundle) else { return }
            content.add(scene)

            scene.position.y = -0.4

            if let subject1 = scene.findEntity(named: "Subject_1") {
                let mc = ManipulationComponent()
                subject1.components.set(mc)
            }

            if let subject2 = scene.findEntity(named: "Subject_2") {
                let mc = ManipulationComponent()
                subject2.components.set(mc)
            }

            if let subject3 = scene.findEntity(named: "Subject_3") {
                let mc = ManipulationComponent()
                subject3.components.set(mc)
            }

        }
    }
}

#Preview {
    Lab079()
}
