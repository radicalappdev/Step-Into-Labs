//  Step Into Vision - Labs
//
//  Title: Lab047
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 4/29/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab047: View {
    var body: some View {
        
        let flowers: [String] = ["🌼", "🌹", "🌷", "🌻", "🌸", "🪻", "🥀", "🪸", "🌾", "💐"]

        RealityView { content, attachments in

            for flower in flowers {
                if let flower = attachments.entity(for: flower)  {

                    // Calculate a random position
                    let x: Float = Float.random(in: -1...1)
                    let y: Float = Float.random(in: 0...2)
                    let z: Float = Float.random(in: -1...1)
                    flower.position = SIMD3<Float>(x, y, z)

                    content.add(flower)


                }

            }


        } update: { content, attachments in

        } attachments: {
            ForEach(flowers, id: \.self) { flower in

                Attachment(id: flower) {
                    Text(flower)
                        .font(.system(size: 144))
                }

            }


        }
    }
}

#Preview {
    Lab047()
}
