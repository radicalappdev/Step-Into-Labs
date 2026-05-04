//  Step Into Vision - Labs
//
//  Title: Lab103
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Featured:
//
//  Created by Joseph Simpson on 5/4/26.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab103: View {
    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "CameraLab", in: realityKitContentBundle) else { return }
            content.add(scene)

        } 
    }
}

#Preview {
    Lab103()
}
