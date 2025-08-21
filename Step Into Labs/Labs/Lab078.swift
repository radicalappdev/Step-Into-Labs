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
                .frame(width: 300, height: 300)
                .frame(depth: 300)
                .glassBackgroundBox(padding: 0)
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
                    Color.blue
                        .glassBackgroundEffect()
                        .padding(padding)
                    Spacer()
                    Color.blue
                        .glassBackgroundEffect()
                        .padding(padding)
                }
                .rotation3DLayout(.degrees(90), axis: .y)

                // Create the top and bottom just the like back and front, but rotate them on x
                ZStack {
                    Color.red
                        .glassBackgroundEffect()
                        .padding(padding)
                    Spacer()
                    Color.red
                        .glassBackgroundEffect()
                        .padding(padding)
                }
                .rotation3DLayout(.degrees(90), axis: .x)

                // Front
                Color.clear
                    .glassBackgroundEffect()
                    .padding(padding)
            }



        }
    }
}

#Preview {
    Lab078()
}
