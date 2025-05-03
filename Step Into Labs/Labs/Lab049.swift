//  Step Into Vision - Labs
//
//  Title: Lab049
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 5/3/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab049: View {
    var body: some View {
        RealityView { content in

            let mat1 = SimpleMaterial(color: .green, roughness: 0.2, isMetallic: false)
            let mat2 = SimpleMaterial(color: .yellow, roughness: 0.2, isMetallic: false)
            let mat3 = SimpleMaterial(color: .orange, roughness: 0.2, isMetallic: false)
            let mat4 = SimpleMaterial(color: .red, roughness: 0.2, isMetallic: false)
            let mat5 = SimpleMaterial(color: .purple, roughness: 0.2, isMetallic: false)
            let mat6 = SimpleMaterial(color: .blue, roughness: 0.2, isMetallic: false)

            let box = ModelEntity(
                mesh: .generateBox(width: 0.5, height: 0.5, depth: 0.5, splitFaces: true),
                materials: [mat1, mat2, mat3, mat4, mat5, mat6])
            box.setPosition([0, -0.1, 0], relativeTo: nil)

            content.add(box)

        }
    }
}

#Preview {
    Lab049()
}
