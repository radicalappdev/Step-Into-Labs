//  Step Into Vision - Labs
//
//  Title: Lab036
//
//  Subtitle: Virtual "Reality" Glasses
//
//  Description: Wait, what?
//
//  Type: Space
//
//  Created by Joseph Simpson on 2/24/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab036: View {
    var body: some View {
        RealityView { content in
            // This loads a pair of classes that uses Occlusion Material on the lenses
            guard let scene = try? await Entity(named: "Glasses", in: realityKitContentBundle) else { return }
            content.add(scene)
            guard let entity = scene.findEntity(named: "Offset") else { return }
            entity.components.set(ManipulationComponent())
        }
    }
}

#Preview {
    Lab036()
}
