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
        VStack(spacing: 18) {

            Text("Shared Visions")
                .font(.extraLargeTitle)
                .shadow(radius: 12)

            Text("Stories from the Apple Vision Pro community.")
                .shadow(radius: 12)

            Button(action: {}, label: {
                Label("Explore", systemImage: "heart.fill")
            })
            .shadow(radius: 12)
        }
        .padding(18)
        .glassBackgroundEffect(
            .feathered(
                padding: 36,
                softEdgeRadius: 4 + (6 * progress)
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
