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

    @State var panes: Edge3D.Set = [.horizontal]
//    @State var panes: Edge3D.Set = [.back, .leading, .trailing, .bottom, .top]

    var body: some View {
        VStack {
            ModelViewSimple(name: "ToyRocket", bundle: realityKitContentBundle)
                .frame(width: 500, height: 500)
                .frame(depth: 500)
                .glassBackgroundBox(padding: 24, panes)
        }
    }
}

extension View {
    func glassBackgroundBox(padding: CGFloat = 0, _ directions: Edge3D.Set) -> some View {

        let topDisplayMode: GlassBackgroundDisplayMode = directions.contains(.top) || directions.contains(.all) || directions.contains(.vertical) ? .always : .never
        let bottomDisplayMode: GlassBackgroundDisplayMode = directions.contains(.bottom) || directions.contains(.all) || directions.contains(.vertical) ? .always : .never
        let leadingDisplayMode: GlassBackgroundDisplayMode = directions.contains(.leading) || directions.contains(.all) || directions.contains(.horizontal) ? .always : .never
        let trailingDisplayMode: GlassBackgroundDisplayMode = directions.contains(.trailing) || directions.contains(.all) || directions.contains(.horizontal) ? .always : .never
        let frontDisplayMode: GlassBackgroundDisplayMode = directions.contains(.front) || directions.contains(.all) || directions.contains(.depth) ? .always : .never
        let backDisplayMode: GlassBackgroundDisplayMode = directions.contains(.back) || directions.contains(.all) || directions.contains(.depth) ? .always : .never

        return
        spatialOverlay {
            ZStack {
                // Back
                Color.clear
                    .glassBackgroundEffect(displayMode: backDisplayMode)
                    .padding(padding)


                // Create the sides just the like back and front, but rotate them on y
                ZStack {
                    Color.clear
                        .glassBackgroundEffect(displayMode: leadingDisplayMode)
                        .padding(padding)
                    Spacer()
                    Color.clear
                        .glassBackgroundEffect(displayMode: trailingDisplayMode)
                        .padding(padding)
                }
                .rotation3DLayout(.degrees(90), axis: .y)

                // Front
                Color.clear
                    .glassBackgroundEffect(displayMode: frontDisplayMode)
                    .padding(padding)
            }



        }
        // Create the top and bottom with another overlay and rotate the panes on the X axis
        .spatialOverlay {
            ZStack {
                Color.clear
                    .glassBackgroundEffect(displayMode: topDisplayMode)
                    .padding(padding)
                Spacer()
                Color.clear
                    .glassBackgroundEffect(displayMode: bottomDisplayMode)
                    .padding(padding)
            }
            .rotation3DLayout(.degrees(90), axis: .x)
        }
    }
}

#Preview {
    Lab078()
}
