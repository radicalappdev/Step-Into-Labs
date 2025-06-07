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
        RealityView { content, attachments in

            var options = MeshResource.ShapeExtrusionOptions()
            options.extrusionMethod = .linear(depth: 0.25)


            guard let mesh = try? await MeshResource(extruding: simplePath(in: CGRect()), extrusionOptions: options) else { return }

            let material = SimpleMaterial(color: .red, isMetallic: false)
            let subject = Entity()
            let meshComponent = ModelEntity(mesh: mesh, materials: [material])
            subject.addChild(meshComponent)

            content.add(subject)


        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
    }
    func simplePath(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.maxY)) // tip at bottom
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY)) // left corner at top
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY)) // right corner at top
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY)) // close the path

        return path
    }
}



#Preview {
    Lab059()
}
