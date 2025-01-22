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

    @State var selectedColorIndex: Int = 0

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
                    let colorEntity = ModelEntity(mesh: .generateSphere(radius: 0.25))
                    colorEntity.name = "Color_\(index)"
                    colorEntity.components.set(HoverEffectComponent())
                    colorEntity.components.set(InputTargetComponent())
                    let collision = CollisionComponent(shapes: [.generateSphere(radius: 0.25)])
                    colorEntity.components.set(collision)


                    var material = PhysicallyBasedMaterial()
                    material.baseColor.tint = .init(color)
                    material.roughness = 0.5
                    material.metallic = 0.0

                    colorEntity.model?.materials = [material]

                    // Calculate position on circle
                    let angle = (Float(index) / totalColors) * 2 * .pi
                    let x = radius * sin(angle)
                    let z = radius * cos(angle)

                    colorEntity.position = SIMD3(x: -x, y: 0, z: z)
                    colorGroup.addChild(colorEntity)
                }

                if let panel = attachments.entity(for: "Panel") {
                    panel.position = SIMD3(x: 0, y: 1.5, z: -1.5)
                    content.add(panel)
                }

            }
        } update: { content, attachments in
            // Empty update closure is fine
        } attachments: {
            Attachment(id: "Panel") {
                VStack {
                    Text("Selected Color")
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color(colors[selectedColorIndex]))
                        .padding()
                }
                .frame(width: 300, height: 200)
                .glassBackgroundEffect()
            }
        }
        .gesture(tapGesture)
        .task {
            while true {
                try? await Task.sleep(for: .milliseconds(16)) // ~60fps
                if isSpinning {
                    colorGroup.orientation *= simd_quatf(angle: .pi/6300, axis: SIMD3<Float>(0, 1, 0)) // 0.5 degrees per frame
                }
            }
        }
    }

    var tapGesture: some Gesture {
        TapGesture(count: 2)
            .targetedToAnyEntity()
            .onEnded { value in
                let name = value.entity.name
                let index = Int(name.split(separator: "_")[1])!
                selectedColorIndex = index
            }
    }
}

#Preview {
    Lab029()
}
