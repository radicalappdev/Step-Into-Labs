//  Step Into Vision - Labs
//
//  Title: Lab100
//
//  Subtitle: Trigger
//
//  Description: Shows the effect of a trigger
//
//  Type: Volume
//
//  Featured: true
//
//  Created by Joseph Simpson on 12/20/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab100: View {

    @State var root = Entity()
    @State var sphere = Entity()
    @State var subscriptions = [EventSubscription]()
    @State var triggerRadius: Float = 0.1

    @State var rootToSphereVectorVisual: Vector?
    @State var triggerSphereVisual: Sphere?

    let modelSortGroup = ModelSortGroup.planarUIAlwaysBehind

    init() {
        registerComponentsAndSystems()
    }

    func registerComponentsAndSystems() {
        DrawComponent.registerComponent()
        DrawRuntimeComponent.registerComponent()
        TriggerComponent.registerComponent()
        TriggerRuntimeComponent.registerComponent()

        DrawSystem.registerSystem()
        TriggerSystem.registerSystem()
    }

    var body: some View {
        RealityView { content in
            setupSphere()
            setupRoot()
            setupVisualizations()
            setupModelSorting()

            root.addChild(sphere)
            content.add(root)

            subscriptions.append(content.subscribe(to: SceneEvents.Update.self, componentType: DrawComponent.self, { event in
                handleUpdate(for: event)
            }))

            subscriptions.append(content.subscribe(to: ComponentEvents.DidChange.self, componentType: TriggerComponent.self, { event in
                handleTriggerDidChange(for: event)
            }))
        }
        .ornament(attachmentAnchor: .scene(.topBack)) {
            ornamentUI
        }
        .preferredWindowClippingMargins(.all, 1000)
    }

    var ornamentUI: some View {
        VStack(alignment: .leading, spacing: 10) {
            let directionVector = normalize(sphere.observable.position - root.observable.position)

            VectorDisplay(title: "Root To Sphere", vector: directionVector)

            let distance = distance(sphere.observable.position, root.observable.position)

            HStack {
                Text("Sphere To Root Distance")
                    .fontWeight(.bold)

                Text(String(format: "%.3f", distance))
            }

            triggerRadiusSlider
        }
        .padding(.horizontal, 40)
        .padding(.vertical)
        .glassBackgroundEffect()
    }

    var triggerRadiusSlider: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Trigger Radius")
                    .fontWeight(.bold)

                Text(String(format: "%.3f", triggerRadius))
            }

            Slider(value: $triggerRadius, in: 0.1...0.5)
                .onChange(of: triggerRadius) { oldValue, newValue in
                    root.scene?.performQuery(DrawSystem.query).forEach { entity in
                        entity.drawRuntimeComponent?.spheres.enumerated().forEach { index, sphere in
                            entity.drawRuntimeComponent?.spheres[index].radius = newValue
                        }
                    }

                    root.scene?.performQuery(TriggerSystem.query).forEach { entity in
                        entity.triggerComponent?.radius = newValue
                    }
                }
        }
    }

    func setupRoot() {
        root.components.set(DrawComponent(showAxes: true))
        root.components.set(DrawRuntimeComponent())
        root.components.set(TriggerComponent(radius: triggerRadius))
        root.components.set(TriggerRuntimeComponent(target: sphere))
        root.addAxes()
    }

    func setupSphere() {
        var material = UnlitMaterial(color: .cyan)
        material.blending = .transparent(opacity: PhysicallyBasedMaterial.Opacity(floatLiteral: 0.5))

        sphere = ModelEntity(
            mesh: .generateSphere(radius: 0.015),
            materials: [material])
        sphere.name = "Sphere"
        sphere.position = [0.2, 0.2, 0.2]

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

    func setupVisualizations() {
        rootToSphereVectorVisual = sphere.addVector(
            from: root.position,
            to: normalize(sphere.position),
            color: .cyan
        )

        triggerSphereVisual = root.addSphere(
            to: root,
            radius: triggerRadius,
            color: .white,
            opacity: 0.1
        )
    }

    func setupModelSorting() {
        triggerSphereVisual?.visualEntity?.components.set(ModelSortGroupComponent(group: modelSortGroup, order: 0))
        root.drawRuntimeComponent?.axes?.components.set(ModelSortGroupComponent(group: modelSortGroup, order: 1))
        sphere.components.set(ModelSortGroupComponent(group: modelSortGroup, order: 2))
        rootToSphereVectorVisual?.visualEntity?.components.set(ModelSortGroupComponent(group: modelSortGroup, order: 3))
    }

    func handleUpdate(for event: Event) {
        sphere.updateVector(with: rootToSphereVectorVisual?.id) { vector in
            vector.start = root.position
            vector.end = sphere.position
        }
    }

    func handleTriggerDidChange(for event: ComponentEvents.DidChange) {
        guard let triggerComponent = event.entity.triggerComponent else { return }

        event.entity.updateSphere(with: triggerSphereVisual?.id) { sphere in
            sphere.color = triggerComponent.isTriggered ? .green : .white
        }
    }
}

#Preview {
    Lab100()
}
