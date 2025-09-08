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

fileprivate struct ShakeScaleComponent: Component {
    var maxMultiplier: Float = 3.0          // cap = baseScale * maxMultiplier
    var distanceThreshold: Float = 0.02     // meters between checks to count as a shake
    var stepFraction: Float = 0.10          // add 10% of base per hit
    // Internal state
    var baseScale: Float? = nil
    var lastPos: SIMD3<Float>? = nil
}

fileprivate struct ShakeScaleSystem: System {
    init(scene: RealityKit.Scene) {

    }

    static let query = EntityQuery(where: .has(ShakeScaleComponent.self) && .has(Transform.self))

    func update(context: SceneUpdateContext) {
        context.scene.performQuery(Self.query).forEach { entity in
            guard var comp = entity.components[ShakeScaleComponent.self] else { return }
            var t = entity.transform

            // Initialize base scale the first time we see the entity
            if comp.baseScale == nil { comp.baseScale = t.scale.x }
            let base = comp.baseScale ?? t.scale.x

            let currentPos = t.translation
            if let last = comp.lastPos {
                let distance = simd_length(currentPos - last)
                if distance > comp.distanceThreshold {
                    let cap = base * comp.maxMultiplier
                    let next = min(t.scale.x + base * comp.stepFraction, cap)
                    if next > t.scale.x {
                        t.scale = .init(repeating: next)
                        entity.transform = t
                    }
                }
            }

            // Book-keeping
            comp.lastPos = currentPos
            entity.components.set(comp)
        }
    }
}

struct Lab080: View {

    init() {
        ShakeScaleComponent.registerComponent()
        ShakeScaleSystem.registerSystem()
    }

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

                // Attach ShakeScaleComponent to each entity using scaleFactor as cap
                rocket.components.set(ShakeScaleComponent(maxMultiplier: scaleFactor))
                car.components.set(ShakeScaleComponent(maxMultiplier: scaleFactor))
                plane.components.set(ShakeScaleComponent(maxMultiplier: scaleFactor))




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
