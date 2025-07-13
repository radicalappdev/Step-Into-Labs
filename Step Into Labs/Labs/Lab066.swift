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
    @State var instanceCount = 3
    @State var offset: Float = 0.05

    var body: some View {
        RealityView { content in

            // Load a scene
            guard let scene = try? await Entity(named: "InstanceLab", in: realityKitContentBundle) else { return }
            content.add(scene)

            // Load an entity
            guard let subject = scene.findEntity(named: "Subject") else { return }

            // Create and set up the component
            var meshInstancesComponent = MeshInstancesComponent()
            do {
                let instances = try LowLevelInstanceData(instanceCount: 20)
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
            content.add(subject)
            subject.position = .init(x: 0, y: -0.4, z: 0)



        }
    }
}

#Preview {
    Lab066()
}
