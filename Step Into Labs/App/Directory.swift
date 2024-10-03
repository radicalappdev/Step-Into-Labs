//
//  ContentView.swift
//  Step Into Labs
//
//  Created by Joseph Simpson on 10/3/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct Directory: View {

    var body: some View {
        VStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            Text("Hello, world!")

        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    Directory()
        .environment(AppModel())
}
