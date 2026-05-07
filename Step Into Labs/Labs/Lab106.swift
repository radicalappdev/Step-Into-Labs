//  Step Into Vision - Labs
//
//  Title: Lab106
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Featured:
//
//  Created by Joseph Simpson on 5/7/26.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab106: View {
    var body: some View {
        RealityView { content in

            guard let rootEntity = try? await Entity(named: "Mist", in: realityKitContentBundle) else { return }
            content.add(rootEntity)

        }
    }
}

#Preview {
    Lab106()
}
