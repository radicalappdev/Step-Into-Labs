//  Step Into Vision - Labs
//
//  Title: Lab056
//
//  Subtitle: Using Emoji in Particle Emitters
//
//  Description: We can render emoji as Texture Resources to be used in our Particle Emitters.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 5/30/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab056: View {

    @State private var selectedEmojo: String = "❤️"

    let emoji = ["❤️", "🎉",  "🏳️‍🌈", "🐸", "🚀", "🌸"]

    var body: some View {
        RealityView { content in

            let subject = Entity()
            subject.name = "Particles"
            content.add(subject)

            // Create the particle emitter
            var particleSystem = ParticleEmitterComponent()
            particleSystem.isEmitting = true
            particleSystem.speed = 0.01
            particleSystem.emitterShape = .sphere
            particleSystem.emitterShapeSize = [0.3, 0.3, 0.3]

            // Set the image to the result of generateTextureFromSystemName using a symbol name
            particleSystem.mainEmitter.image = generateTextureFromEmoji(selectedEmojo)
            particleSystem.mainEmitter.birthRate = 25
            particleSystem.mainEmitter.size = 0.1

            // Setting the color is a little annoying
            // Issues: I haven't found a way to specify no color for the particles.
            // The best option I found is to provide a white constant color. This will tint the emoji a bit.
            let color = ParticleEmitterComponent.ParticleEmitter.Color(.white)
            let singleColorValue = ParticleEmitterComponent.ParticleEmitter.ParticleColor.ColorValue.single(color)
            let constantColor = ParticleEmitterComponent.ParticleEmitter.ParticleColor.constant(singleColorValue)
            particleSystem.mainEmitter.color = constantColor

            // Add the component to the entity
            subject.components.set(particleSystem)

        } update: { content in

            if let subject = content.entities.first?.findEntity(named: "Particles") {
                if var particleSystem = subject.components[ParticleEmitterComponent.self] {
                    particleSystem.mainEmitter.image = generateTextureFromEmoji(selectedEmojo)
                    subject.components.set(particleSystem)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                HStack {
                    ForEach(emoji, id: \.self) { symbol in
                        Text(symbol)
                            .frame(width: 32, height: 32)
                            .foregroundColor(.white)
                            .onTapGesture {
                                selectedEmojo = symbol
                            }
                            .padding(6)
                            .background( selectedEmojo == symbol ? .white : Color.clear)
                            .clipShape(.circle)
                    }
                }
            })
        }
    }

    // Adapted from generateTextureFromSystemName in the example project called "Simulating particles in your visionOS app"
    // Sources: https://developer.apple.com/documentation/realitykit/simulating-particles-in-your-visionos-app
    func generateTextureFromEmoji(_ emoji: String) -> TextureResource? {
        // Create aa image from an emoji
        let imageSize = CGSize(width: 128, height: 128)

        // Start the graphics context
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)

        // Create an attributed string with the emoji
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 96)  // Large size to fill the texture
        ]
        let attributedString = NSAttributedString(string: emoji, attributes: attributes)

        // Calculate the size of the emoji
        let stringSize = attributedString.size()

        // Calculate the position to center the emoji
        let x = (imageSize.width - stringSize.width) / 2
        let y = (imageSize.height - stringSize.height) / 2

        // Draw the emoji
        attributedString.draw(at: CGPoint(x: x, y: y))

        // Get the image from the context
        let contextImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Convert to texture resource
        guard let coreGraphicsImage = contextImage?.cgImage else {
            return nil
        }

        let creationOptions = TextureResource.CreateOptions(semantic: .raw)
        return try? TextureResource(image: coreGraphicsImage, options: creationOptions)
    }
}

#Preview {
    Lab056()
}
