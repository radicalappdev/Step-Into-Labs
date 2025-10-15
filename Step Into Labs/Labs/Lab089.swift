//  Step Into Vision - Labs
//
//  Title: Lab089
//
//  Subtitle: Loading Materials
//
//  Description: Exploring a few ways to load materials from Reality Composer Pro.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 10/15/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab089: View {

    @State var subject = Entity()

    @State var mat1: PhysicallyBasedMaterial?
    @State var mat2: ShaderGraphMaterial?
    @State var mat3: ShaderGraphMaterial?

    var body: some View {
        VStack {
            Spacer()
            RealityView { content in

                guard let scene = try? await Entity(named: "MaterialLoadingLab", in: realityKitContentBundle) else { return }
                content.add(scene)

                guard let subject = scene.findEntity(named: "Subject") else { return }
                self.subject = subject

                // Example 01: Get the first material from an entity Model Component
                // This is the only way I know of to load a PhysicallyBasedMaterial from Reality Composer Pro
                if let material = subject.components[ModelComponent.self]?.materials.first as? PhysicallyBasedMaterial {
                    mat1 = material
                }

                // Example 02: Load a material using name and filename
                // named: the full path to the material in the graph
                // from: the full filename, may include extension
                if let material = try? await ShaderGraphMaterial(
                    named: "/Root/Subject/GlossyRed",
                    from: "MaterialLoadingLab",
                    in: realityKitContentBundle
                ) {
                    mat2 = material
                }

                // Example 03: Load one of the materials from the Content Library
                // These materials are provided as USDZ files. Most use the material name as the root prim
                if let material = try? await ShaderGraphMaterial(
                    named: "/MaplePlywood",
                    from: "MaplePlywood",
                    in: realityKitContentBundle
                ) {
                    mat3 = material
                }


            }
            .realityViewLayoutBehavior(.flexible)
            .preferredWindowClippingMargins(.all, 200)
        }
        .toolbar {
            ToolbarItem(
                placement: .bottomOrnament,
                content: {
                    HStack {
                        Button(action: {

                            if let mat1 = mat1 {
                                subject.components[ModelComponent.self]?.materials[0] = mat1
                            }

                        }, label: {
                            Text("PBR From Entity")
                        })

                        Button(action: {
                            if let mat2 = mat2 {
                                subject.components[ModelComponent.self]?.materials[0] = mat2
                            }
                        },
                               label: {
                            Text("Shader Graph 02")
                        })

                        Button(action: {
                            if let mat3 = mat3 {
                                subject.components[ModelComponent.self]?.materials[0] = mat3
                            }
                        },
                               label: {
                            Text("Shader Graph 02")
                        })

                    }
                })
        }
    }

}

#Preview {
    Lab089()
}




