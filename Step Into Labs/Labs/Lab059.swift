//  Step Into Vision - Labs
//
//  Title: Lab059
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 6/7/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab059: View {
    var body: some View {
        RealityView { content in
            var options = MeshResource.ShapeExtrusionOptions()
            options.extrusionMethod = .linear(depth: 0.5)


            guard let mesh = try? await MeshResource(extruding: simplePath(), extrusionOptions: options) else { return }

            let material = SimpleMaterial(color: .stepGreen, isMetallic: false)
            let subject = Entity()
            let meshComponent = ModelEntity(mesh: mesh, materials: [material])


            subject.addChild(meshComponent)

            content.add(subject)

        } update: { content in

        }
    }
    func simplePath() -> Path {
        let rect = CGRect(x: -0.1, y: -0.1, width: 0.2, height: 0.2)
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))

        return path
    }
}

#Preview {
    Lab059()
}
