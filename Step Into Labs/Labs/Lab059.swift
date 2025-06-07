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
    @State private var extrusionDepth: Float = 0.01

    var body: some View {
        RealityView { content in
            // Create the 3D extruded shape
            var options = MeshResource.ShapeExtrusionOptions()
            options.extrusionMethod = .linear(depth: extrusionDepth)
            guard let mesh = try? await MeshResource(extruding: simplePath(), extrusionOptions: options) else { return }

            // Set up an entity and add it to the scene.
            let material = SimpleMaterial(color: .stepGreen, isMetallic: false)
            let subject = ModelEntity(mesh: mesh, materials: [material])
            subject.name = "Subject"
            subject.orientation = .init(angle: .pi / 4, axis: [0, 1, 0])

            content.add(subject)
            
        } update: { content in
            // Update the extrusion depth when it changes
            if let subject = content.entities.first?.findEntity(named: "Subject") {
                var options = MeshResource.ShapeExtrusionOptions()
                options.extrusionMethod = .linear(depth: extrusionDepth)
                
                Task {
                    // Get the existing model component from the subject and replace the mesh with a new one using the
                    if let newMesh = try? await MeshResource(extruding: simplePath(), extrusionOptions: options) {
                        if var modelComponent = subject.components[ModelComponent.self] {
                            modelComponent.mesh = newMesh
                            subject.components.set(modelComponent)
                        }
                    }
                }
            }
        }
        .task {
            // Animate the value of extrusionDepth over time in a sequence
            // Note: it would be great if we could animate values with Timeline in Reality Composer Pro
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            
            let startTime = Date()
            let duration: TimeInterval = 2.0
            let min: Float  = 0.01
            let max: Float = 0.5
            while true {
                let elapsed = Date().timeIntervalSince(startTime)
                let cycleTime = elapsed.truncatingRemainder(dividingBy: 7.0) // 7 second cycle
                
                if cycleTime < 1.0 {
                    extrusionDepth = min
                } else if cycleTime < 3.0 {
                    let progress = (cycleTime - 1.0) / duration
                    extrusionDepth = min + Float(progress) * (max - 0.01)
                } else if cycleTime < 4.0 {
                    extrusionDepth = max
                } else if cycleTime < 6.0 {
                    let progress = (cycleTime - 4.0) / duration
                    extrusionDepth = max - Float(progress) * (max - 0.01)
                } else {
                    extrusionDepth = min
                }
                
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
