//  Step Into Vision - Labs
//
//  Title: Lab090
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 10/16/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab090: View {

    @State private var manipulationStart: SIMD3<Float> = .zero
    @State private var manipulationMaxDistanceSquared: Float = .zero

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "ObserveEntity", in: realityKitContentBundle) else { return }
            scene.position.y = -0.4
            content.add(scene)

            guard let subject = scene.findEntity(named: "ToyRocket") else { return }
            let mc = ManipulationComponent()
            subject.components.set(mc)

            _ = content.subscribe(to: ManipulationEvents.WillBegin.self) { event in
                manipulationStart = event.entity.position
                manipulationMaxDistanceSquared = .zero
            }

            _ = content.subscribe(to: ManipulationEvents.DidUpdateTransform.self) { event in
                let distanceSquared = simd_distance_squared(manipulationStart, event.entity.position)
                if manipulationMaxDistanceSquared < distanceSquared {
                    manipulationMaxDistanceSquared = distanceSquared
                }

            }

            _ = content.subscribe(to: ManipulationEvents.WillEnd.self)  { event in
                if(manipulationMaxDistanceSquared < 0.01 * 0.01) {
                    print("tapped registered")
                } else {
                    print("manipulation registered")
                }

            }

        }
    }
}

#Preview {
    Lab090()
}
