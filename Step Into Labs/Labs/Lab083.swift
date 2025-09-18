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
    @State private var progress: CGFloat = 0.0

    var body: some View {
        ZStack {
            Text("Feathered Glass Background Effect")
                .font(.extraLargeTitle)
        }
        .glassBackgroundEffect(
            .feathered(
                padding: 36,
                softEdgeRadius: 3 + (9 * progress) // min 3, animates up to 12
            ),
            displayMode: .always
        )

        .onAppear {
            withAnimation(.easeInOut(duration: 4.0).repeatForever()) {
                progress = 1.0
            }
        }
    }
}

#Preview {
    Lab083()
}
