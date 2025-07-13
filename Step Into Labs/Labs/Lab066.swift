//  Step Into Vision - Labs
//
//  Title: Lab066
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 7/7/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab066: View {
    @State var instanceCount = 1
    @State var offset: Float = 0.05

    var body: some View {
        RealityView { content in

            // Load a scene
            guard let scene = try? await Entity(named: "InstanceLab", in: realityKitContentBundle) else { return }
            content.add(scene)

            // Load an entity and set it up for input
            guard let subject = scene.findEntity(named: "Subject") else { return }
            subject.components.set(InputTargetComponent())
            subject.components.set(HoverEffectComponent())
            subject.components
                .set(CollisionComponent(shapes: [.generateBox(width: 0.1, height: 0.1, depth: 0.1)], isStatic: false))

            // When we tap on the subject, we'll create create new instances
            let tapGesture = TapGesture()
                .onEnded({ [weak subject] _ in
                    guard let subject = subject else { return }
                    instanceCount += 1

                    // Create and set up the component
                    var meshInstancesComponent = MeshInstancesComponent()
                    do {
                        let instances = try LowLevelInstanceData(instanceCount: instanceCount)
                        // The tricky part can be getting the correct part index
                        meshInstancesComponent[partIndex: 0] = .init(data: instances)

                        // Loop over each instance and update the transform
                        instances.withMutableTransforms { transforms in
                            for i in 0..<instanceCount {

                                // For this example, we'll only edit the position / translation. We can also edit the scale and rotation if needed.
                                let offset: Float = 0.05 * Float(i)
                                var transform = Transform()

                                transform.translation = [offset, offset, offset]
                                transforms[i] = transform.matrix

                            }
                        }

                        subject.components.set(meshInstancesComponent)

                    } catch {
                        print("error creating instances = \(error)")
                    }

                })
            
            let gestureComponent = GestureComponent(tapGesture)
            subject.components.set(gestureComponent)

            subject.position = .init(x: 0, y: -0.3, z: 0)

        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                Text("Instances: \(instanceCount)")
            })
        }
    }
}

#Preview {
    Lab066()
}
