//  Step Into Vision - Labs
//
//  Title: Lab057
//
//  Subtitle: Using Opacity Component with Particle Emitters
//
//  Description: We can use Opacity Component on an entity with a Particle System to fade out all particles together.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 6/4/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab057: View {

    @State private var value: Float = 1

    var body: some View {
        RealityView { content in

            let subject = Entity()
            subject.name = "Particles"
            content.add(subject)

            var particleSystem = ParticleEmitterComponent()
            particleSystem.isEmitting = true
            particleSystem.speed = 0.01
            particleSystem.emitterShape = .sphere
            particleSystem.emitterShapeSize = [0.3, 0.3, 0.3]

            particleSystem.mainEmitter.birthRate = 25
            particleSystem.mainEmitter.size = 0.1

            let color = ParticleEmitterComponent.ParticleEmitter.Color(.stepRed)
            let singleColorValue = ParticleEmitterComponent.ParticleEmitter.ParticleColor.ColorValue.single(color)
            let constantColor = ParticleEmitterComponent.ParticleEmitter.ParticleColor.constant(singleColorValue)
            particleSystem.mainEmitter.color = constantColor

            subject.components.set(particleSystem)

        } update: { content in

            if let subject = content.entities.first?.findEntity(named: "Particles") {
                let opacity = OpacityComponent(opacity: value)
                subject.components.set(opacity)
            }

        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                HStack {
                    Slider(value: $value,
                           in: 0.0...1.0,
                           minimumValueLabel: Image(systemName: "circle"),
                           maximumValueLabel: Image(systemName: "circle.fill"),
                           label: {
                        Text("Opacity")
                    })
                    .frame(width: 240)
                }
            })
        }
    }

}

#Preview {
    Lab057()
}
