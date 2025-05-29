//  Step Into Vision - Labs
//
//  Title: Lab054
//
//  Subtitle: Oops all Hover Effects
//
//  Description: Just a bit of fun with hover effect namespaces.
//
//  Type: Window
//
//  Created by Joseph Simpson on 5/29/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab054: View {
    @Namespace private var hoverNamespace

    var body: some View {
        ZStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 12), spacing: 4) {
                ForEach(0..<96, id: \.self) { index in
                    Shrug(hoverNamespace: hoverNamespace)
                        .offset(y: index % 2 == 0 ? 24 : 0)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack {
                Button(action: {
                    print("")
                }, label: {
                    HStack {
                        Text("Hover Me")
                    }
                })
                .glassBackgroundEffect()
                .hoverEffect(in: HoverEffectGroup(hoverNamespace)) { effect, isActive, proxy in
                    effect.animation(.easeOut) {
                        $0.rotationEffect(.degrees(isActive ? -15 : 0), anchor: .center)

                    }
                }

            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .glassBackgroundEffect()
    }
}

fileprivate struct Shrug: View {
    // There may be a better way to pass the namespace to this view, but this works
    var hoverNamespace: Namespace.ID

    var body: some View {
        Text("🤷🏻‍♂️")
            .font(.extraLargeTitle2)
            .hoverEffect(in: HoverEffectGroup(hoverNamespace)) { effect, isActive, proxy in
                effect.opacity(isActive ? 0.3 : 0)
            }
    }
}

#Preview {
    Lab054()
}
