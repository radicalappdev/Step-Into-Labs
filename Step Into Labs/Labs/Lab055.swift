//  Step Into Vision - Labs
//
//  Title: Lab055
//
//  Subtitle: Using SF Symbols in Particle Emitters
//
//  Description: We can create Texture Resources to be used in our Particle Emitters.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 6/01/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab055: View {

    @State private var selectedSymbol: String = "vision.pro.fill"

    let symbols = ["vision.pro.fill", "macpro.gen3.fill",  "macbook.gen2", "iphone", "applewatch", "ipad"]

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
            particleSystem.mainEmitter.image = generateTextureFromSystemName(selectedSymbol)
            particleSystem.mainEmitter.birthRate = 25
            particleSystem.mainEmitter.size = 0.1

            // Add the component to the entity
            subject.components.set(particleSystem)

        } update: { content in

            if let subject = content.entities.first?.findEntity(named: "Particles") {
                if var particleSystem = subject.components[ParticleEmitterComponent.self] {
                    particleSystem.mainEmitter.image = generateTextureFromSystemName(selectedSymbol)
                    subject.components.set(particleSystem)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                HStack {
                    ForEach(symbols, id: \.self) { symbol in
                        Image(systemName: symbol)
                            .frame(width: 32, height: 32)
                            .foregroundColor(.white)
                            .onTapGesture {
                                selectedSymbol = symbol
                            }
                            .padding(6)
                            .background( selectedSymbol == symbol ? .purple : Color.clear)
                            .clipShape(.circle)
                    }
                }
            })
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
        print("symbol size \(symbolSize)")
        
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
        print("draw rect \(drawRect)")

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
    Lab055()
}
