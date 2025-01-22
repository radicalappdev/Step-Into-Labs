//  Step Into Vision - Labs
//
//  Title: Lab029
//
//  Subtitle: Baggage Claim
//
//  Description: What if a using a color picker was like waiting at baggage claim?
//
//  Type: Space
//
//  Created by Joseph Simpson on 1/22/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab029: View {
    @State private var colors: [Color] = [
        .red,
        .pink,
        .orange,
        .yellow,
        .green,
        .mint,
        .teal,
        .cyan,
        .blue,
        .indigo,
        .purple,
        .brown,
        .white,
        Color(uiColor: .systemGray),
        Color(uiColor: .systemGray2),
        Color(uiColor: .systemGray3),
        Color(uiColor: .systemGray4),
        Color(uiColor: .systemGray5),
        Color(uiColor: .systemGray6),
        .black
    ]

    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "BaggageClaim", in: realityKitContentBundle) {
                content.add(scene)

                let colorGroup = Entity()
                colorGroup.name = "ColorGroup"
                colorGroup.position = SIMD3(x: 0, y: 1, z: -2)
                scene.addChild(colorGroup)
                for (index, color) in colors.enumerated() {
                    let cube = ModelEntity(mesh: .generateBox(size: 0.2))
                    cube.name = "Color_\(index)"

                    let uiColor = UIColor(color)
                    cube.model?.materials = [SimpleMaterial(color: uiColor, isMetallic: false)]

                    cube.position = SIMD3(x: -0.4 * Float(index), y: 0, z: 0)
                    colorGroup.addChild(cube)
                }
            }

        } update: { content, attachments in
            // Empty update closure is fine
        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
    }
}

#Preview {
    Lab029()
}
