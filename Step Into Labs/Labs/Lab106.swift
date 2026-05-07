//  Step Into Vision - Labs
//
//  Title: Lab106
//
//  Subtitle: Mist
//
//  Description: I'm using this lab to build a basic scene that will be used for some other ideas later.
//
//  Type: Space
//
//  Featured: true
//
//  Created by Joseph Simpson on 5/7/26.
//  boat_ornament by The Base Mesh [CC0]
//  sundial by The Base Mesh [CC0]
//  crt_monitor by The Base Mesh [CC0]
//  retro_computer by The Base Mesh [CC0]

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
