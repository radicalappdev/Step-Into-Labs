//  Step Into Vision - Labs
//
//  Title: Lab028
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 1/21/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab028: View {

    @State var ornamentAnchor: UnitPoint = .top

    var body: some View {
        VStack {

        }
        .ornament(attachmentAnchor: .scene(ornamentAnchor)) {
            Text("Ornament")
                .padding(20)
                .background(.stepBlue)
                .cornerRadius(20)
        }
    }
}

#Preview {
    Lab028()
}
