//  Step Into Vision - Labs
//
//  Title: Lab054
//
//  Subtitle:
//
//  Description:
//
//  Type:
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
                ForEach(0..<96, id: \.self) { _ in
                    Shrug(hoverNamespace: hoverNamespace)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack {
                Button(action: {
                    print("")
                }, label: {
                    HStack {
                        Text("What tilt hover effect?")
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
    @State var hoverNamespace: Namespace.ID

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
