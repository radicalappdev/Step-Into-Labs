//  Step Into Vision - Labs
//
//  Title: Lab078
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 8/20/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab078: View {
    var body: some View {
        VStack {
            ModelViewSimple(name: "ToyRocket", bundle: realityKitContentBundle)
                .frame(width: 500, height: 500)
                .frame(depth: 500)
                .glassBackgroundBox(padding: 24)
        }
    }
}

extension View {
    func glassBackgroundBox(padding: CGFloat = 0) -> some View {
        spatialOverlay {
            ZStack {
                // Back
                Color.clear
                    .glassBackgroundEffect()
                    .padding(padding)

                // Create the sides just the like back and front, but rotate them on y
                ZStack {
                    Color.clear
                        .glassBackgroundEffect()
                        .padding(padding)
                    Spacer()
                    Color.clear
                        .glassBackgroundEffect()
                        .padding(padding)
                }
                .rotation3DLayout(.degrees(90), axis: .y)

                // Front
                Color.clear
                    .glassBackgroundEffect()
                    .padding(padding)
            }



        }
        // Create the top and bottom with another overlay and rotate the panes on the X axis
        .spatialOverlay {
            ZStack {
                Color.clear
                    .glassBackgroundEffect()
                    .padding(padding)
                Spacer()
                Color.clear
                    .glassBackgroundEffect()
                    .padding(padding)
            }
            .rotation3DLayout(.degrees(90), axis: .x)
        }
    }
}

#Preview {
    Lab078()
}
