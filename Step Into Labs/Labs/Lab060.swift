//  Step Into Vision - Labs
//
//  Title: Lab060
//
//  Subtitle: First look at Manipulation Component
//
//  Description: A simple but powerful component to interact with entities in RealityKit.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 6/11/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab060: View {

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "GestureLabs", in: realityKitContentBundle) else { return }
                content.add(scene)

            scene.position.y = -0.4

            if let car = scene.findEntity(named: "ToyCar") {
                // Using the ManipulationComponent defaults
                let mc = ManipulationComponent()
                car.components.set(mc)
            }

            if let rocket = scene.findEntity(named: "ToyRocket") {
                // Changing the release behavior
                var mc = ManipulationComponent()
                mc.releaseBehavior = .stay
                rocket.components.set(mc)
            }

            if let plane = scene.findEntity(named: "ToyBiplane") {
                // Removing translation and scaling
                var mc = ManipulationComponent()
                mc.dynamics.translationBehavior = .none
                mc.dynamics.scalingBehavior = .none
                plane.components.set(mc)
            }

        }
    }
}

#Preview {
    Lab060()
}
