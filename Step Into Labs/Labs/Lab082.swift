//  Step Into Vision - Labs
//
//  Title: Lab082
//
//  Subtitle: Using implicit glassBackgroundEffect with depth
//
//  Description: We can use implicit display mode to show glass on views that have a Z offset.
//
//  Type: Window
//
//  Created by Joseph Simpson on 9/17/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab082: View {

    @State private var showBackground = true
    @State private var showDepth = false

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            HStack {
                CardView(imageName: "applewatch.watchface", title: "Apple Watch", caption: "Series 11")
                    .offset(z: showDepth ? 40 : 0)

                CardView(imageName: "iphone.gen3", title: "iPhone", caption: "Pro 17, Silver")
                    .offset(z: showDepth ? 120 : 0)

                CardView(imageName: "airpods.pro", title: "AirPods Pro", caption: "3rd Generation")
                    .offset(z: showDepth ? 80 : 0)
            }
            Spacer()
        }
        .padding(60)

        .glassBackgroundEffect(displayMode: showBackground ? .always : .never)
        .ornament(attachmentAnchor: .scene(.bottom), ornament: {
            HStack{
                Toggle(isOn: $showBackground.animation()) {
                    Text("Background")
                }
                .toggleStyle(.button)
                Toggle(isOn: $showDepth.animation()) {
                    Text("Depth")
                }
                .toggleStyle(.button)
            }
            .controlSize(.small)
            .padding(4)
            .glassBackgroundEffect()
        })
    }
}

fileprivate struct CardView : View {

    @State var imageName: String
    @State var title: String
    @State var caption: String

    var body: some View {
        VStack {
            Image(systemName: imageName)
                .font(.largeTitle)
            Text(title)
                .font(.title)
            Text(caption)
                .font(.caption)

        }
        .padding(12)
        .frame(width: 180, height: 120,)


        // Each card uses implicit display mode
        .glassBackgroundEffect(displayMode: .implicit)


    }
}


#Preview {
    Lab082()
}
