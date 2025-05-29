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
        VStack {
            Button(action: {
                print("")
            }, label: {
                HStack {
                    Text("Hover Me")
                    Text("🤷🏻‍♂️")
                        .hoverEffect(in: HoverEffectGroup(hoverNamespace)) { effect, isActive, _ in
                            effect.opacity(isActive ? 1.0 : 0)
                        }
                }
            })
            .hoverEffect(in: HoverEffectGroup(hoverNamespace)) { effect, isActive, proxy in
                effect.animation(.easeOut) {
                    
                    $0.rotationEffect(.degrees(isActive ? -15 : 0), anchor: .bottomTrailing)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .glassBackgroundEffect()
        .hoverEffect(in: HoverEffectGroup(hoverNamespace)) { effect, isActive, _ in
            effect.animation(.easeOut) {
                $0.rotationEffect(.degrees(isActive ? 15 : 0), anchor: .center)
                .scaleEffect(isActive ? 0.75 : 1)
            }
        }
    }
}




#Preview {
    Lab054()
}
