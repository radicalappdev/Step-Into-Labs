//  Step Into Vision - Labs
//
//  Title: Lab010
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 10/24/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab010: View {
    var body: some View {
        RealityView { content in
            // Load the scene from the Reality Kit bindle
            if let scene = try? await Entity(named: "Lab010Scene", in: realityKitContentBundle) {
                content.add(scene)


            }
        }
    }
}

#Preview {
    Lab010()
}
