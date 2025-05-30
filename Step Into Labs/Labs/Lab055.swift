//  Step Into Vision - Labs
//
//  Title: Lab055
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 5/30/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab055: View {
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
            particleSystem.mainEmitter.image = generateTextureFromSystemName("heart.fill")
            particleSystem.mainEmitter.birthRate = 25
            particleSystem.mainEmitter.size = 0.1

            // Add the component to the entity
            subject.components.set(particleSystem)

        } update: { content in

        }
    }

    // Credit: Apple provided this function in the example project called "Simulating particles in your visionOS app"
    // Sources: https://developer.apple.com/documentation/realitykit/simulating-particles-in-your-visionos-app
    func generateTextureFromSystemName( _ name: String) -> TextureResource? {
        let imageSize = CGSize(width: 128, height: 128)

        // Create a UIImage from a symbol name.
        guard var symbolImage = UIImage(systemName: name) else {
            return nil
        }

        // Create a new version that always uses the template rendering mode.
        symbolImage = symbolImage.withRenderingMode(.alwaysTemplate)

        // Start the graphics context.
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)

        // Set the color's texture to white so that the app can apply a color
        // on top of the image.
        UIColor.white.set()

        // Draw the image with the context.
        let rectangle = CGRect(origin: CGPoint.zero, size: imageSize)
        symbolImage.draw(in: rectangle, blendMode: .normal, alpha: 1.0)

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
    Lab055()
}
