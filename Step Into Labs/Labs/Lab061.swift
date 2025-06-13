//  Step Into Vision - Labs
//
//  Title: Lab061
//
//  Subtitle: First look at SwiftUI animations in RealityKit
//
//  Description: Using the new content.animate method to apply a SwiftUI animation to a RealityKit entity.
//
//  Type: Volume
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
            .animation(.easeInOut(duration: 2))
    }

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "SwiftUIAnimationLab", in: realityKitContentBundle) else { return }
            content.add(scene)

            if let subject = scene.findEntity(named: "Subject") {
                self.subject = subject
            }

        } update: { content in

            // Using content.animate here, but there is also an Entity animate I need to check out
            content.animate {
                let scaler: Float = subjectToggle ? 2.0 : 1.0
                subject.scale = .init(repeating: scaler)
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
