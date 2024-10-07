//  Step Into Vision - Labs
//
//  Title: Lab005
//
//  Subtitle: Animate Offset & rotation3DEffect
//
//  Description: Using rotation3DEffect along with offset to create a pseudo-3D layout. This is a revamped version of Canvatorium Visio Lab 5006, adapted for Step Into Vision.
//
//  Type:
//
//  Created by Joseph Simpson on 10/7/24.

import SwiftUI
import RealityKit

struct Lab005: View {
    @State private var isClicked = false
    var body: some View {
        VStack(alignment: .center) {
            Toggle(isOn: $isClicked.animation()) {
                Text("Show Depth")
            }
            .toggleStyle(.button)
            HStack {
                Rectangle()
                    .foregroundColor(.stepRed)
                    .cornerRadius(24)
                    .shadow(radius: 20)
                    .offset(x: isClicked ? -40 : 0)
                    .offset(z: isClicked ? 80 : 1)
                    .rotation3DEffect(
                        Angle(degrees: isClicked ? 25 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                Rectangle()
                    .foregroundColor(.stepGreen)
                    .cornerRadius(24)
                    .shadow(radius: 20)
                    .offset(z: isClicked ? 50 : 1)
                Rectangle()
                    .foregroundColor(.stepBlue)
                    .cornerRadius(24)
                    .shadow(radius: 20)
                    .offset(x: isClicked ? 40 : 0)
                    .offset(z: isClicked ? 80 : 1)
                    .rotation3DEffect(
                        Angle(degrees: isClicked ? -25 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
            }
        }
        .padding(60)
    }
}

#Preview {
    Lab005()
}
