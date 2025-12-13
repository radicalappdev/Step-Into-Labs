//  Step Into Vision - Labs
//
//  Title: Lab098
//
//  Subtitle: Vector Subtraction
//
//  Description: Visualizes the subtraction of two vectors
//
//  Type: Volume
//
//  Created by Tempuno e.U. on 20.10.25.

import RealityKit
import RealityKitContent
import SwiftUI

enum VectorSubtractionShowCases: String, CaseIterable, Identifiable {
    case boxMinusSphere = "Box Minus Sphere"
    case sphereMinusBox = "Sphere Minus Box"
    case both = "Both Subtractions"

    var id: Self { self }
}

struct Lab098: View {

    @State var box = Entity()
    @State var root = Entity()
    @State var selectedShowCase: VectorSubtractionShowCases = .both
    @State var sphere = Entity()
    @State var subscriptions = [EventSubscription]()

    @State var rootToBoxVectorVisual: Vector?
    @State var rootToSphereVectorVisual: Vector?
    @State var boxToBoxMinusSphereVectorVisual: Vector?
    @State var rootToBoxMinusSphereVectorVisual: Vector?
    @State var sphereToSphereMinusBoxVectorVisual: Vector?
    @State var rootToSphereMinusBoxVectorVisual: Vector?

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
            setupBox()
            setupRoot()
            setupSphere()
            setupVisualizations()

            root.addChild(box)
            root.addChild(sphere)
            content.add(root)

            subscriptions.append(content.subscribe(to: SceneEvents.Update.self, componentType: DrawComponent.self, { event in
                handleUpdate(for: event)
            }))

            handleShowcase(selectedShowCase)
        }
        .ornament(attachmentAnchor: .scene(.topBack)) {
            ornamentUI
        }
        .preferredWindowClippingMargins(.all, 1000)
    }

    var ornamentUI: some View {
        VStack(alignment: .leading, spacing: 10) {
            showCasePicker

            let rootToBoxVector = box.observable.position - root.observable.position
            let rootToSphereVector = sphere.observable.position - root.observable.position
            let boxMinusSphereVector = rootToBoxVector - rootToSphereVector
            let sphereMinusBoxVector = rootToSphereVector - rootToBoxVector

            VectorDisplay(title: "Root to Box", vector: rootToBoxVector)
            VectorDisplay(title: "Root to Sphere", vector: rootToSphereVector)
            VectorDisplay(title: "Box Minus Sphere", vector: boxMinusSphereVector)
            VectorDisplay(title: "Sphere Minus Box", vector: sphereMinusBoxVector)
        }
        .padding(.horizontal, 40)
        .padding(.vertical)
        .glassBackgroundEffect()
    }

    var showCasePicker: some View {
        HStack {
            Text("Showcase")
                .fontWeight(.bold)

            Spacer()

            Picker("Showcase", selection: $selectedShowCase) {
                ForEach(VectorSubtractionShowCases.allCases) { showCase in
                    Text(showCase.rawValue)
                        .tag(showCase as VectorSubtractionShowCases)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: selectedShowCase, initial: true) { oldValue, newValue in
                handleShowcase(newValue)
            }
        }
    }

    func setupRoot() {
        root.components.set(DrawComponent(showAxes: true))
        root.components.set(DrawRuntimeComponent())
    }

    func setupSphere() {
        var material = UnlitMaterial(color: .cyan)
        material.blending = .transparent(opacity: PhysicallyBasedMaterial.Opacity(floatLiteral: 0.8))

        sphere = ModelEntity(
            mesh: .generateSphere(radius: 0.015),
            materials: [material])
        sphere.name = "Sphere"
        sphere.position = [0.1, 0.15, 0]

        var manipulationComponent = ManipulationComponent()
        manipulationComponent.releaseBehavior = .stay
        manipulationComponent.dynamics.primaryRotationBehavior = .none
        manipulationComponent.dynamics.secondaryRotationBehavior = .none
        manipulationComponent.dynamics.scalingBehavior = .none
        manipulationComponent.dynamics.inertia = .zero
        sphere.components.set(manipulationComponent)
        sphere.generateCollisionShapes(recursive: true)
        sphere.components.set(InputTargetComponent())
        sphere.components.set(HoverEffectComponent())
        sphere.components.set(DrawComponent())
        sphere.components.set(DrawRuntimeComponent())
    }

    func setupBox() {
        var material = UnlitMaterial(color: .orange)
        material.blending = .transparent(opacity: PhysicallyBasedMaterial.Opacity(floatLiteral: 0.8))

        box = ModelEntity(
            mesh: .generateBox(size: 0.03),
            materials: [material])
        box.name = "Box"
        box.position = [-0.1, 0.15, 0]

        var manipulationComponent = ManipulationComponent()
        manipulationComponent.releaseBehavior = .stay
        manipulationComponent.dynamics.primaryRotationBehavior = .none
        manipulationComponent.dynamics.secondaryRotationBehavior = .none
        manipulationComponent.dynamics.scalingBehavior = .none
        manipulationComponent.dynamics.inertia = .zero
        box.components.set(manipulationComponent)
        box.generateCollisionShapes(recursive: true)
        box.components.set(InputTargetComponent())
        box.components.set(HoverEffectComponent())
        box.components.set(DrawComponent())
        box.components.set(DrawRuntimeComponent())
    }

    func setupVisualizations() {
        rootToBoxVectorVisual = root.addVector(
            from: root.position,
            to: box.position,
            color: .orange
        )

        rootToSphereVectorVisual = root.addVector(
            from: root.position,
            to: sphere.position,
            color: .cyan
        )

        boxToBoxMinusSphereVectorVisual = box.addVector(
            from: box.position,
            to: box.position - sphere.position,
            color: .cyan
        )

        rootToBoxMinusSphereVectorVisual = root.addVector(
            from: root.position,
            to: box.position - sphere.position,
            color: .white
        )

        sphereToSphereMinusBoxVectorVisual = sphere.addVector(
            from: sphere.position,
            to: sphere.position - box.position,
            color: .orange
        )

        rootToSphereMinusBoxVectorVisual = root.addVector(
            from: root.position,
            to: sphere.position - box.position,
            color: .white
        )
    }

    func handleUpdate(for event: Event) {
        root.updateVector(with: rootToBoxVectorVisual?.id) { vector in
            vector.start = root.position
            vector.end = box.position
        }

        root.updateVector(with: rootToSphereVectorVisual?.id) { vector in
            vector.start = root.position
            vector.end = sphere.position
        }

        box.updateVector(with: boxToBoxMinusSphereVectorVisual?.id) { vector in
            vector.start = box.position
            vector.end = box.position - sphere.position
        }

        root.updateVector(with: rootToBoxMinusSphereVectorVisual?.id) { vector in
            vector.start = root.position
            vector.end = box.position - sphere.position
        }

        sphere.updateVector(with: sphereToSphereMinusBoxVectorVisual?.id) { vector in
            vector.start = sphere.position
            vector.end = sphere.position - box.position
        }

        root.updateVector(with: rootToSphereMinusBoxVectorVisual?.id) { vector in
            vector.start = root.position
            vector.end = sphere.position - box.position
        }
    }

    func handleShowcase(_ showcase: VectorSubtractionShowCases) {
        let showBoxMinusSphere = showcase == .boxMinusSphere || showcase == .both
        let showSphereMinusBox = showcase == .sphereMinusBox || showcase == .both

        box.updateVector(with: boxToBoxMinusSphereVectorVisual?.id) { $0.isEnabled = showBoxMinusSphere }
        root.updateVector(with: rootToBoxMinusSphereVectorVisual?.id) { $0.isEnabled = showBoxMinusSphere }
        sphere.updateVector(with: sphereToSphereMinusBoxVectorVisual?.id) { $0.isEnabled = showSphereMinusBox }
        root.updateVector(with: rootToSphereMinusBoxVectorVisual?.id) { $0.isEnabled = showSphereMinusBox }
    }
}

#Preview(windowStyle: .volumetric) {
    Lab098()
}
