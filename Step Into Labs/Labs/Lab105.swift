//  Step Into Vision - Labs
//
//  Title: Lab105
//
//  Subtitle: Vapor
//
//  Description: I'm using this lab to build a basic scene that will be used for some other ideas later.
//
//  Type: Space
//
//  Featured: true
//
//  Created by Joseph Simpson on 5/6/26.
//  Palm tree by Poly by Google [CC-BY], via Poly Pizza
//  Column_Round3 by Quaternius [CCO]
//  crt_monitor by The Base Mesh [CC0]
//  retro_computer by The Base Mesh [CC0]

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab105: View {
    var body: some View {
        RealityView { content in

            guard let rootEntity = try? await Entity(named: "Vapor", in: realityKitContentBundle) else { return }
            content.add(rootEntity)

        }
    }
}

#Preview {
    Lab105()
}
