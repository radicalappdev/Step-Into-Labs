//  Step Into Vision - Labs
//
//  Title: Lab094
//
//  Subtitle: Visualize a Pivot Point
//
//  Description:
//
//  Type: Volume
//
//  Michael Temper: https://bsky.app/profile/michaeltemper.bsky.social

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab094: View {

    @Environment(\.realityKitScene) var scene

    @State var root = Entity()
    @State var showAxes = true
    @State var sphere = Entity()

    @State var xAxisLabel = Entity(components: [ViewAttachmentComponent(rootView: Text("X").font(.largeTitle)), BillboardComponent()])
    @State var yAxisLabel = Entity(components: [ViewAttachmentComponent(rootView: Text("Y").font(.largeTitle)), BillboardComponent()])
    @State var zAxisLabel = Entity(components: [ViewAttachmentComponent(rootView: Text("Z").font(.largeTitle)), BillboardComponent()])

    init() {
        registerComponentsAndSystems()
    }

    func registerComponentsAndSystems() {
        DrawComponent.registerComponent()
        DrawRuntimeComponent.registerComponent()

        DrawSystem.registerSystem()
    }

    var body: some View {
        RealityView { content in
            setupRoot()
            setupSphere()

            root.addChild(sphere)
            content.add(root)
        }
        .ornament(attachmentAnchor: .scene(.topBack)) {
            ornamentUI
        }
        .onChange(of: showAxes) { oldValue, newValue in
            xAxisLabel.isEnabled = newValue
            yAxisLabel.isEnabled = newValue
            zAxisLabel.isEnabled = newValue

            scene?.performQuery(DrawSystem.query).forEach { entity in
                entity.drawComponent?.showAxes = newValue
            }
        }
    }

    var ornamentUI: some View {
        VStack {
            Toggle(isOn: $showAxes.animation()) {
                Text(showAxes ? "Hide Axes" : "Show Axes")
            }
            .toggleStyle(.button)
        }
        .padding()
        .fixedSize()
        .glassBackgroundEffect()
    }

    func setupRoot() {
        root.components.set(DrawComponent(showAxes: showAxes))
        root.components.set(DrawRuntimeComponent())

        let axisLength: Float = 0.25
        let offset: Float = 0.02
        xAxisLabel.position.x = axisLength + offset
        yAxisLabel.position.y = axisLength + offset
        zAxisLabel.position.z = axisLength + offset

        root.addChild(xAxisLabel)
        root.addChild(yAxisLabel)
        root.addChild(zAxisLabel)
    }

    func setupSphere() {
        var material = UnlitMaterial(color: .cyan)
        material.blending = .transparent(opacity: PhysicallyBasedMaterial.Opacity(floatLiteral: 0.5))

        sphere = ModelEntity(
            mesh: .generateSphere(radius: 0.015),
            materials: [material])
        sphere.name = "Sphere"
        sphere.position = [0.1, 0.1, 0.1]

        var manipulationComponent = ManipulationComponent()
        manipulationComponent.releaseBehavior = .stay
        manipulationComponent.dynamics.scalingBehavior = .none
        manipulationComponent.dynamics.inertia = .zero
        sphere.components.set(manipulationComponent)
        sphere.generateCollisionShapes(recursive: true)
        sphere.components.set(InputTargetComponent())
        sphere.components.set(HoverEffectComponent())
        sphere.components.set(DrawComponent(showAxes: showAxes))
        sphere.components.set(DrawRuntimeComponent())
    }
}

#Preview {
    Lab094()
}
