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

    @State var isSpinning: Bool = true
    @State var colorGroup = Entity()

    var body: some View {
        RealityView { content, attachments in
            if let scene = try? await Entity(named: "BaggageClaim", in: realityKitContentBundle) {
                content.add(scene)

                colorGroup.name = "ColorGroup"
                colorGroup.position = SIMD3(x: 0, y: 1, z: -5)
                scene.addChild(colorGroup)

                let radius: Float = 2.5 // 5 meter diameter
                let totalColors = Float(colors.count)

                for (index, color) in colors.enumerated() {
                    let cube = ModelEntity(mesh: .generateBox(size: 0.3))
                    cube.name = "Color_\(index)"

                    let uiColor = UIColor(color)
                    cube.model?.materials = [SimpleMaterial(color: uiColor, isMetallic: false)]


                    // Calculate position on circle
                    let angle = (Float(index) / totalColors) * 2 * .pi
                    let x = radius * sin(angle)
                    let z = radius * cos(angle)

                    //                        cube.setPosition([-x, 0, z], relativeTo: colorGroup)
                    cube.position = SIMD3(x: -x, y: 0, z: z)
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
        .task {
            while true {
                try? await Task.sleep(for: .milliseconds(16)) // ~60fps
                if isSpinning {
                    colorGroup.orientation *= simd_quatf(angle: .pi/6300, axis: SIMD3<Float>(0, 1, 0)) // 0.5 degrees per frame
                }
            }
        }
    }
}

#Preview {
    Lab029()
}
