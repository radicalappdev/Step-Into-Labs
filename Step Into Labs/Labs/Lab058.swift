//  Step Into Vision - Labs
//
//  Title: Lab058
//
//  Subtitle: Particles Emitting Particles
//
//  Description: We can setup the main particle emitter to spawn sub-particles.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 6/5/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab058: View {

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

            // Set up the main particles
            // Set the image to the result of generateTextureFromSystemName using a symbol name
            particleSystem.mainEmitter.image = generateTextureFromSystemName("heart.fill")
            particleSystem.mainEmitter.birthRate = 4
            particleSystem.mainEmitter.size = 0.1
            particleSystem.mainEmitter.lifeSpan = 1
            particleSystem.mainEmitter.color = .constant(.single(.systemPurple))
            particleSystem.mainEmitter.sizeMultiplierAtEndOfLifespan = 1 // prevent them from being scaled down

            // Setup the subparticles
            // Make sure to initial initialize the spawned emitter
            particleSystem.spawnedEmitter = .init()
            particleSystem.spawnOccasion = .onUpdate
            particleSystem.spawnedEmitter?.birthRate = 16
            particleSystem.spawnedEmitter?.image = generateTextureFromSystemName("heart.fill")
            particleSystem.spawnedEmitter?.size = 0.05
            particleSystem.spawnedEmitter?.spreadingAngle = 0.5
            particleSystem.spawnedEmitter?.color = .constant(.single(.systemPink))
            particleSystem.spawnSpreadFactor = 0.2

            // Add the component to the entity
            subject.components.set(particleSystem)

        }

    }

    // Credit: Apple provided this function in the example project called "Simulating particles in your visionOS app"
    // Sources: https://developer.apple.com/documentation/realitykit/simulating-particles-in-your-visionos-app
    func generateTextureFromSystemName( _ name: String) -> TextureResource? {
        // Create a UIImage from a symbol name.
        guard var symbolImage = UIImage(systemName: name) else {
            return nil
        }

        // Create a new version that always uses the template rendering mode.
        symbolImage = symbolImage.withRenderingMode(.alwaysTemplate)

        // Get the natural size of the symbol
        let symbolSize = symbolImage.size

        // Create a square texture
        let textureSize: CGFloat = 128
        let imageSize = CGSize(width: textureSize, height: textureSize)

        // Calculate the aspect ratio and scaled size
        let aspectRatio = symbolSize.width / symbolSize.height
        let scaledSize: CGSize
        if aspectRatio > 1 {
            // Wider than tall
            scaledSize = CGSize(width: textureSize, height: textureSize / aspectRatio)
        } else {
            // Taller than wide or square
            scaledSize = CGSize(width: textureSize * aspectRatio, height: textureSize)
        }

        // Calculate the position to center the symbol
        let x = (textureSize - scaledSize.width) / 2
        let y = (textureSize - scaledSize.height) / 2
        let drawRect = CGRect(origin: CGPoint(x: x, y: y), size: scaledSize)

        // Start the graphics context.
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)

        // Set the color's texture to white so that the app can apply a color
        // on top of the image.
        UIColor.white.set()

        // Draw the image with the context, centered in the square
        symbolImage.draw(in: drawRect, blendMode: .normal, alpha: 1.0)

        // Retrieve the image from the context.
        let contextImage = UIGraphicsGetImageFromCurrentImageContext()

        // End the graphics context.
        UIGraphicsEndImageContext()

        // Retrieve the Core Graphics version of the image.
        guard let coreGraphicsImage = contextImage?.cgImage else {
            return nil
        }

        // Generate the texture resource from the Core Graphics image.
        let creationOptions = TextureResource.CreateOptions(semantic: .raw)
        return try? TextureResource(image: coreGraphicsImage,
                                    options: creationOptions)
    }
}

#Preview {
    Lab058()
}
