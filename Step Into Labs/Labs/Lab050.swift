//  Step Into Vision - Labs
//
//  Title: Lab050
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 5/4/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab050: View {
    var body: some View {
        HStack(spacing: 12) {
            ShapeHoverDemo(color: .stepRed)
            ShapeHoverDemo(color: .stepGreen)
            ShapeHoverDemo(color: .stepBlue)
        }
        .padding()
    }
}

private struct ShapeHoverDemo: View {

    // 1. Create a namespace
    @Namespace private var hoverNamespace

    @State var color: Color = .stepRed

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(color)

            Image(systemName: "star.fill")
                .foregroundColor(.white)
                .font(.largeTitle)
                // 2. Use HoverEffectGroup with the namespace we defined above
                .hoverEffect(in: HoverEffectGroup(hoverNamespace)) { effect, isActive, proxy in
                    effect.opacity(isActive ? 1.0 : 0)
                }
        }
        // 2. Use HoverEffectGroup with the namespace we defined above
        .hoverEffect(in: HoverEffectGroup(hoverNamespace)) { effect, isActive, proxy in
            // Hack: just return the effect without applying it to any view
            // This let's us use the shape of the ZStack to receive hover focus, without applying a visual change to it
            effect
        }
        .aspectRatio(4/3, contentMode: .fit)
        .clipShape(.rect(cornerRadius: 24))

    }
}

#Preview {
    Lab050()
}
