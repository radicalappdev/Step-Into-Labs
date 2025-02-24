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

            if let scene = try? await Entity(named: "Glasses", in: realityKitContentBundle) {
                content.add(scene)
            }
        }
        .modifier(DragGestureImproved())
        .modifier(ScaleAndRotateGesture())
    }
}

#Preview {
    Lab036()
}
