//  Step Into Vision - Labs
//
//  Title: Lab049
//
//  Subtitle: Split Faces
//
//  Description: Using a different material on each face of a box.
//
//  Type: Volume
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

            let box1 = ModelEntity(
                mesh: .generateBox(width: 0.2, height: 0.2, depth: 0.2, splitFaces: true),
                materials: [mat1, mat2, mat3, mat4, mat5, mat6])
            box1.setPosition([-0.2, 0.2, 0], relativeTo: nil)

            let box2 = ModelEntity(
                mesh: .generateBox(width: 0.2, height: 0.2, depth: 0.2, cornerRadius: 0.03, splitFaces: true),
                materials: [mat1, mat2, mat3, mat4, mat5, mat6])

            let box3 = ModelEntity(
                mesh: .generateBox(width: 0.2, height: 0.2, depth: 0.2, cornerRadius: 0.1, splitFaces: true),
                materials: [mat1, mat2, mat3, mat4, mat5, mat6])
            box3.setPosition([0.2, -0.2, 0], relativeTo: nil)

            content.add(box1)
            content.add(box2)
            content.add(box3)

            // Spin the boxex so we can see all faces
            Task {
                let action = SpinAction(revolutions: 1,
                                        localAxis: [0.5, 0.5, 0],
                                        timingFunction: .linear,
                                        isAdditive: false)
                let animation = try AnimationResource.makeActionAnimation(for: action,
                                                                          duration: 10,
                                                                          bindTarget: .transform,
                                                                          repeatMode: .repeat)
                box1.playAnimation(animation)
                box2.playAnimation(animation)
                box3.playAnimation(animation)
            }


        }
    }
}

#Preview {
    Lab049()
}
