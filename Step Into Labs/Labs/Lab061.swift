//  Step Into Vision - Labs
//
//  Title: Lab061
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 6/12/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab061: View {

    @State private var subject = Entity()
    @State private var subjectToggle = false

    // See "Better together: SwiftUI and RealityKit" WWDC 2025
    var animatedIsOffset: Binding<Bool> {
    $subjectToggle
        .animation(.bouncy(extraBounce: 0.1))
    }

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "SwiftUIAnimationLab", in: realityKitContentBundle) else { return }
            content.add(scene)

            if let subject = scene.findEntity(named: "Subject") {
                self.subject = subject
            }


        } update: { content in

            content.animate {
                // Example 1: change the scale
                let scaler: Float = subjectToggle ? 2.0 : 1.0
                subject.scale = .init(repeating: scaler)

                // Example 2: change the color of the material
                let color: Color = subjectToggle ? .stepRed : .stepGreen
                if var material = subject.components[ModelComponent.self]?.materials.first as? PhysicallyBasedMaterial {
                    material.baseColor.tint = UIColor(color)
                    subject.components[ModelComponent.self]?.materials[0] = material
                }
            }

        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                Toggle(isOn: animatedIsOffset, label: {
                    Text("Toggle Subject")
                })
            })
        }
    }
}



#Preview {
    Lab061()
}
