//  Step Into Vision - Labs
//
//  Title: Lab005
//
//  Subtitle:
//
//  Description:
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
                    .offset(x: isClicked ? -60 : 0)
                    .offset(z: isClicked ? 60 : 1)
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
                    .offset(x: isClicked ? 60 : 0)
                    .offset(z: isClicked ? 60 : 1)
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
