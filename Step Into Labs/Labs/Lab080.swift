//  Step Into Vision - Labs
//
//  Title: Lab080
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 8/30/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab080: View {

    // Set up the base
    @State var subject: Entity = {
        let mat = SimpleMaterial(color: .stepGreen, roughness: 0.2, isMetallic: false)
        let box = ModelEntity(
            mesh: .generateBox(width: 1, height: 0.1, depth: 1, cornerRadius: 0.06),
            materials: [mat])
        return box
    }()

    var body: some View {
        GeometryReader3D { proxy in
            VStack {
                Spacer()

                RealityView { content in
                    content.add(subject)
                } update: { content in

                    // Update the subject scale anytime the proxy changes
                    scaleSubjectWithFrame(content: content, proxy: proxy, subject: subject)

                }
                .realityViewLayoutBehavior(.fixedSize)
                .debugBorder3D(.white)
            }
            .frame(depth: proxy.size.depth)
            .frame(width: proxy.size.width, height: proxy.size.height)
            .debugBorder3D(.blue)
        }
    }

    func scaleSubjectWithFrame(content: RealityViewContent, proxy: GeometryProxy3D, subject: Entity) {
        let newFrame = content.convert(proxy.frame(in: .global), from: .global, to: .scene)
        print("new frame requested \(newFrame.extents)")
        subject.scale = [newFrame.extents.x, newFrame.extents.y, newFrame.extents.z]
    }
}

#Preview {
    Lab080()
}
