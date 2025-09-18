//  Step Into Vision - Labs
//
//  Title: Lab083
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 9/18/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab083: View {
    var body: some View {
        ZStack {

            Text("Feathered Glass Background Effect")
                .font(.extraLargeTitle)
            
        }
        .glassBackgroundEffect(.feathered(padding: 36, softEdgeRadius: 3), displayMode: .always)
    }
}

#Preview {
    Lab083()
}
