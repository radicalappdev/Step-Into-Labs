//  Step Into Vision - Labs
//
//  Title: Lab065
//
//  Subtitle: First look at the Manipulable modifier
//
//  Description: A SwiftUI modifier that works just like Manipulation Component from RealityKit.
//
//  Type: Window
//
//  Created by Joseph Simpson on 6/19/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab065: View {

    @State private var manipulationState = Manipulable.GestureState()
    var body: some View {
        VStack {

            // Manipulate a Model3D - intended use
            Model3D(named: "ToyCar", bundle: realityKitContentBundle)
                .manipulable()

            // Manipulate a 2D View - where they expecting this?
            HStack {
                Text("Hello Manipulable Modifier")
                    .font(.extraLargeTitle)
                    .padding()
            }
            .frame(width: 300, height: 200)
            .background(.black)
            .clipShape(.rect(cornerRadius: 12))
            .hoverEffect()
            .manipulable()

        }

    }
}

#Preview {
    Lab065()
}
