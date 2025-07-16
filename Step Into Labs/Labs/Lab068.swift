//  Step Into Vision - Labs
//
//  Title: Lab068
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 7/16/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab068: View {
    var body: some View {
        ModelViewSimple(name: "UISphere01", bundle: realityKitContentBundle)
            .frame(width: 60)
            .spatialOverlay(alignment:  .center) {
                Text("🌸")
                    .font(.system(size: 30))
            }
    }
}

#Preview {
    Lab068()
}
