//  Step Into Vision - Labs
//
//  Title: Lab080
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 8/30/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab080: View {

    @State private var transform: Transform?

    @State private var scaleFactor: Float = 3.0

    var body: some View {
        VStack {
            Spacer()
            RealityView { content in
                // Load a scene
                guard let shakeLab = try? await Entity(named: "ShakeLab", in: realityKitContentBundle) else { return }
                shakeLab.position.y = -0.4
                content.add(shakeLab)

                let mc = ManipulationComponent()
                guard let rocket = shakeLab.findEntity(named: "ToyRocket") else { return }
                rocket.components.set(mc)

                guard let car = shakeLab.findEntity(named: "ToyCar") else { return }
                car.components.set(mc)

                guard let plane = shakeLab.findEntity(named: "ToyBiplane") else { return }
                plane.components.set(mc)

                _ = content.subscribe(to: ManipulationEvents.DidUpdateTransform.self) { event in
                    // TODO: check to see if we have performed rapid movements and add scale
                }

                _ = content.subscribe(to: ManipulationEvents.WillEnd.self)  { event in
                    transform = nil
                }

            }

        }
    }


}

#Preview {
    Lab080()
}
