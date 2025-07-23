//  Step Into Vision - Labs
//
//  Title: Lab073
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 7/23/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab073: View {
    var body: some View {
        RealityView { content in

            // Load the UI Sphere from some previous labs. This has the materal I want to use
            guard let scene = try? await Entity(named: "UISphere01", in: realityKitContentBundle) else { return }
            guard let material = scene.findEntity(named: "Sphere")?.components[ModelComponent.self]?.materials.first as? PhysicallyBasedMaterial else { return }
            // We don't need the mesh or the rest of the scene so we won't bother adding it to the context.

            // Create a box with rounded corners
            let subject = ModelEntity(
                mesh: .generateBox(width: 0.1, height: 0.1, depth: 0.04, cornerRadius: 0.01, splitFaces: false),
                materials: [material])
            subject.name = "UIBox01"

            subject.position = [0.8, 1.6, -1.5]

            content.add(subject)



        } 
    }
}


