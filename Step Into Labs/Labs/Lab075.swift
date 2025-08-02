//  Step Into Vision - Labs
//
//  Title: Lab075
//
//  Subtitle: Visualizing SwiftUI Frames
//
//  Description: Using an incredibly useful view extension from WWDC 2025 to debug and visualize spatial layouts.
//
//  Type: Window
//
//  Created by Joseph Simpson on 8/2/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab075: View {
    var body: some View {
        HStackLayout(spacing: 12).depthAlignment(.center) {

            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.stepRed)
                    .offset(z: -25)
                RoundedRectangle(cornerRadius: 8)
                    .fill(.stepGreen)
                RoundedRectangle(cornerRadius: 8)
                    .fill(.stepBlue)
                    .offset(z: 25)
            }
            .frame(width: 200, height: 300)
            .frame(depth: 50)
            .debugBorder3D(.white)

            VStackLayout(spacing: 8).depthAlignment(.center) {
                ModelViewSimple(name: "ToyRocket", bundle: realityKitContentBundle)
                    .frame(width: 100, height: 100)
                    .debugBorder3D(.stepRed)
                    .spatialOverlay(alignment: .bottomFront, content: {
                        Text("Toy Rocket")
                            .font(.caption)
                            .padding(8)
                            .background(.black)
                            .clipShape(.capsule)
                    })

                ModelViewSimple(name: "ToyCar", bundle: realityKitContentBundle)
                    .frame(width: 100, height: 100)
                    .debugBorder3D(.stepGreen)
                    .spatialOverlay(alignment: .bottomFront, content: {
                        Text("Toy Car")
                            .font(.caption)
                            .padding(8)
                            .background(.black)
                            .clipShape(.capsule)
                    })

                ModelViewSimple(name: "ToyBiplane", bundle: realityKitContentBundle)
                    .frame(width: 100, height: 100)
                    .debugBorder3D(.stepBlue)
                    .spatialOverlay(alignment: .bottomFront, content: {
                        Text("Toy Biplane")
                            .font(.caption)
                            .padding(8)
                            .background(.black)
                            .clipShape(.capsule)
                    })
            }
            .padding()
            .debugBorder3D(.white)

        }
        .padding()
        .debugBorder3D(.black)
    }
}
