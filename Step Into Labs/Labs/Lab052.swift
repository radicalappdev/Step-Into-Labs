//  Step Into Vision - Labs
//
//  Title: Lab052
//
//  Subtitle: A 3D text countdown timer
//
//  Description: Originally created for Looming Deadlines
//
//  Type: Window
//
//  Created by Joseph Simpson on 5/8/25.

import SwiftUI
import RealityKit
import RealityKitContent
import Combine

struct Lab052: View {
    @State var someDate = Date().addingTimeInterval(36000)
    var body: some View {
        CountdownWrapper(deadline: $someDate) { duration in
            CountdownValue3D(timerString: duration)
        }
    }
}

fileprivate var durationFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute, .second]
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = .default
    return formatter
}()

fileprivate struct CountdownWrapper<Content: View>: View {
    @Binding var deadline: Date
    @State private var duration = ""
    @State private var repeatingTimer: AnyCancellable?

    let content: (Binding<String>) -> Content

    var body: some View {
        VStack {
            if duration.isEmpty {
                ProgressView()

            } else {
                content($duration)
            }
        }
        .onAppear {
            startInitialTimer()
        }
        .onDisappear {
            stopRepeatingTimer()
        }
    }

    private func startInitialTimer() {
        let now = Date()
        let nextFullSecond = ceil(now.timeIntervalSinceReferenceDate)
        let delay = nextFullSecond - now.timeIntervalSinceReferenceDate

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.startRepeatingTimer()
            self.updateDuration()
        }
    }

    private func startRepeatingTimer() {
        repeatingTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.updateDuration()
            }
    }

    private func stopRepeatingTimer() {
        repeatingTimer?.cancel()
    }

    private func updateDuration() {
        // TODO: I've seen crashes here with a warning about "index out of range"
        // NOTE: This stopped happening when I removed the countdown from the list view
        var delta = deadline.timeIntervalSince(Date())
        if delta <= 0 {
            delta = 0
            stopRepeatingTimer()
        }
        duration = durationFormatter.string(from: delta) ?? ""
    }
}

fileprivate struct CountdownValue3D: View {
    @Binding var timerString: String

    var body: some View {
        ZStack {
            GeometryReader3D { proxy in
                CountdownValue3DScene(timerString: $timerString, proxy: proxy)
                    .frame(idealHeight: 30)
            }
        }
        .frame(depth: 100, alignment: DepthAlignment.back)
    }
}

fileprivate struct CountdownValue3DScene: View {
    @Binding var timerString: String
    
    var proxy: GeometryProxy3D

    @State private var modelEntity: ModelEntity?

    var body: some View {
        RealityView { content in
            if modelEntity == nil {
                let entity = makeTextEntity(timerString: timerString)
                modelEntity = entity
                entity.scaleToFit(proxy: proxy, content: content, yOffset: 0.02)
                entity.name = "text3D"
                content.add(entity)
            }
        } update: { content in
            for entity in content.entities {
                if entity.name == "text3D", let textEntity = entity as? ModelEntity {
                    textEntity.model = makeTextEntity(timerString: timerString).model
                    textEntity.scaleToFit(proxy: proxy, content: content, yOffset: 0.02)
                }
            }
        }
    }

    @MainActor private let faceMaterial: PhysicallyBasedMaterial = {
        var faceMaterial = PhysicallyBasedMaterial()
        faceMaterial.metallic = .init(floatLiteral: 1)
        faceMaterial.baseColor = .init(tint: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        return faceMaterial
    }()

    @MainActor private let borderMaterial: PhysicallyBasedMaterial = {
        var borderMaterial = PhysicallyBasedMaterial()
        borderMaterial.metallic = .init(floatLiteral: 0.15)
        borderMaterial.roughness = .init(floatLiteral: 0.85)
        borderMaterial.baseColor = .init(tint: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        return borderMaterial
    }()


    private func makeTextEntity(timerString: String) -> ModelEntity {

        var textString = AttributedString(timerString)
        textString.font = .monospacedSystemFont(ofSize: 8.0, weight: .heavy)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        textString.mergeAttributes(AttributeContainer([.paragraphStyle: paragraphStyle]))

        var textOptions = MeshResource.GenerateTextOptions()
        textOptions.containerFrame = CGRect(x: 0, y: 0, width: 100, height: 50)

        var extrusionOptions = MeshResource.ShapeExtrusionOptions()
        extrusionOptions.extrusionMethod = .linear(depth: 1)
        extrusionOptions.materialAssignment = .init(front: 0, back: 0, extrusion: 1, frontChamfer: 1, backChamfer: 1)
        extrusionOptions.chamferRadius = 0.1

        let textMesh = try! MeshResource(extruding: textString,
                                         textOptions: textOptions,
                                         extrusionOptions: extrusionOptions)

        return ModelEntity(mesh: textMesh, materials: [faceMaterial, borderMaterial])
    }
}

fileprivate extension Entity {
    func scaleToFit(proxy: GeometryProxy3D, content: RealityViewContent, scaler: Float = 0.8, yOffset: Float = 0.0) {
        guard let model = components[ModelComponent.self] else { return }

        let frame = proxy.frame(in: .local)
        let frameCenter = content.convert(frame.center, from: .local, to: .scene)
        let frameSize = abs(content.convert(frame.size, from: .local, to: .scene))

        let bounds = model.mesh.bounds
        let extents = bounds.extents
        let center = bounds.center

        let graphicScale = min(frameSize.x / extents.x, frameSize.y / extents.y)

        scale = SIMD3<Float>(repeating: graphicScale * scaler)
        position = frameCenter - SIMD3<Float>(0, 0 + yOffset, 0)
        position -= center * (graphicScale * scaler)
    }
}



