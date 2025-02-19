//  Step Into Vision - Labs
//
//  Title: Lab034
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 2/19/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab034: View {

    @State var sceneContent: Entity?

    var body: some View {
        RealityView { content in

            if let scene = try? await Entity(named: "TeleportLabs", in: realityKitContentBundle) {
                content.add(scene)

                // Get the scene content and stash it in state
                if let sceneContent = scene.findEntity(named: "Root") {
                    self.sceneContent = sceneContent
                }

                
            }

        }
    }
}

#Preview {
    Lab034()
}
