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
        NavigationStack {

            VStack {
                LabList()
                    .navigationTitle("Step Into Labs")
            }
        }
        .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
        .ornament(attachmentAnchor: .scene(.top)) {
            HStack {
                Text("https://stepinto.vision/category/labs/")
            }
            .padding(20)
            .background(.thickMaterial)
            .glassBackgroundEffect()
            .cornerRadius(20)

        }



    }
}

#Preview(windowStyle: .automatic) {
    let modelData = ModelData()
    return Directory()
        .environment(modelData)
}
