//  Step Into Vision - Labs
//
//  Title: Lab019
//
//  Subtitle: Material Sandbox
//
//  Description: Just a lab I'm using to view various materials in visionOS
//
//  Type: Space
//
//  Created by Joseph Simpson on 12/17/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab019: View {
    var body: some View {
        RealityView { content in
            if let scene = try? await Entity(named: "MaterialSandbox", in: realityKitContentBundle) {
                print("scene loaded")
                scene.position = .init(x: 0, y: 1.5, z: -1.5)
                content.add(scene)
            }
        }
    }
}

#Preview {
    Lab019()
}
