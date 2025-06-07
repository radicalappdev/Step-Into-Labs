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
    @State private var extrusionDepth: Float = 0.0
    
    var body: some View {
        RealityView { content, attachments in
            // Create the 3D extruded shape
            var options = MeshResource.ShapeExtrusionOptions()
            options.extrusionMethod = .linear(depth: extrusionDepth)
            
            guard let mesh = try? await MeshResource(extruding: simplePath(), extrusionOptions: options) else { return }
            
            let material = SimpleMaterial(color: .stepGreen, isMetallic: false)
            var subject = Entity()
            subject.name = "Subject"
            let meshComponent = ModelEntity(mesh: mesh, materials: [material])
            
            subject.addChild(meshComponent)
            content.add(subject)
            
        } update: { content, attachments in
            // Update the extrusion depth when it changes
            if let entity = content.entities.first?.findEntity(named: "Subject") {
                var options = MeshResource.ShapeExtrusionOptions()
                options.extrusionMethod = .linear(depth: extrusionDepth)
                
                Task {
                    if let newMesh = try? await MeshResource(extruding: simplePath(), extrusionOptions: options) {
                        if let modelEntity = entity.children.first as? ModelEntity {
                            modelEntity.model?.mesh = newMesh
                        }
                    }
                }
            }
        } attachments: {
            Attachment(id: "2DShape") {
                // 2D shape that matches the 3D extrusion
                Path { path in
                    let rect = CGRect(x: -0.1, y: -0.1, width: 0.2, height: 0.2)
                    path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
                    path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
                    path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
                    path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
                }
                .stroke(.stepGreen, lineWidth: 0.01)
                .frame(width: 0.2, height: 0.2)
            }
        }
        .task {
            let startTime = Date()
            while true {
                let elapsed = Date().timeIntervalSince(startTime)
                let progress = Float(elapsed.truncatingRemainder(dividingBy: 2.0) / 2.0)
                
                // Smooth easing function
                let eased = 0.5 - cos(progress * .pi) * 0.5
                extrusionDepth = eased * 0.5 // Scale to max depth of 0.5
                
                try? await Task.sleep(nanoseconds: 1_000_000_000 / 60) // 60 FPS
            }
        }
    }
    
    func simplePath() -> Path {
        let rect = CGRect(x: -0.1, y: -0.1, width: 0.2, height: 0.2)
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        
        return path
    }
}

#Preview {
    Lab059()
}
