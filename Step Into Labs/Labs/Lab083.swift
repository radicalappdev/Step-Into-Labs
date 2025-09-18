//  Step Into Vision - Labs
//
//  Title: Lab083
//
//  Subtitle: Feathered glass title card
//
//  Description: A mock up of a title card for the Shared Visions Project.
//
//  Type: Window
//
//  Created by Joseph Simpson on 9/18/25.

import SwiftUI
import RealityKit
import RealityKitContent

private struct TitleWidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = max(value, nextValue()) }
}

struct Lab083: View {
    @State private var progress: CGFloat = 0.0
    @State private var titleWidth: CGFloat = 0

    var body: some View {
        VStack(spacing: 18) {

            Text("Shared Visions")
                .font(.extraLargeTitle)
                .shadow(radius: 12)
                .fixedSize() // measure intrinsic width, not expanded width
                .background(
                    GeometryReader { g in
                        Color.clear.preference(key: TitleWidthKey.self, value: g.size.width)
                    }
                )

            Text("Stories from the Apple Vision Pro community.")
                .shadow(radius: 12)
                .multilineTextAlignment(.center)
                .frame(width: titleWidth) // matches the title’s width
                .lineLimit(1)
                .minimumScaleFactor(0.5)

            Button(action: {}, label: {
                Label("Explore", systemImage: "heart.fill")
            })
            .shadow(radius: 12)
        }
        .onPreferenceChange(TitleWidthKey.self) { titleWidth = $0 }
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
        .persistentSystemOverlays(.hidden)
    }
}


#Preview {
    Lab083()
}
