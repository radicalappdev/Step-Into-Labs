//  Step Into Vision - Labs
//
//  Title: Lab017
//
//  Subtitle: Exploring a Skybox Material with Shader Graph
//
//  Description: Having a little fun with occlusion too.
//
//  Type:
//
//  Created by Joseph Simpson on 12/11/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab017: View {

    @State var showSkyLarge: Bool = false

    var body: some View {
        RealityView { content in

            if let scene = try? await Entity(named: "Lab017Scene", in: realityKitContentBundle) {
                content.add(scene)
            }

        } update: {content in

            guard let root = content.entities.first else { return }
            if let skySphere = root.findEntity(named: "SkySphere"), let occSphere = root.findEntity(named: "OccSphere") {

                skySphere.scale = showSkyLarge ? [10, 10, 10] : [0.5, 0.5, 0.5]
                occSphere.scale = showSkyLarge ? [0.5, 0.5, 0.5] : [10, 10, 10]

                if(showSkyLarge) {
                    occSphere.position = skySphere.position
                } else {
                    skySphere.position = occSphere.position
                }

            }

        }
        .gesture(tap)
        .modifier(DragGestureImproved())

    }

    var tap: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded {_ in
                showSkyLarge.toggle()
            }
    }
}


#Preview {
    Lab017()
}
