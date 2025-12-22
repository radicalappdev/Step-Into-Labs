//  Step Into Vision - Labs
//
//  Title: Lab095
//
//  Subtitle: World, Local & Object Space
//
//  Description: Shows the movement in World, Local and Object Space
//
//  Type: Volume
//
//  Created by Michael Temper on 11/22/25.
//
//  Follow: https://bsky.app/profile/michaeltemper.bsky.social

import RealityKit
import RealityKitContent
import SwiftUI

enum SelectableCoordinateSpace: String, CaseIterable, Identifiable {
    case world = "World"
    case local = "Local"
    case object = "Object"

    var id: Self { self }
}

struct Lab095: View {

    @State var box = Entity()
    @State var root = Entity()
    @State var selectedSpace: SelectableCoordinateSpace = .local
    @State var sphere = Entity()
    @State var subscriptions = [EventSubscription]()

    @State var boxPosition: SIMD3<Float> = [0.2, 0.2, 0.2]
    @State var boxObjectOrigin: SIMD3<Float> = .zero

    let modelSortGroup = ModelSortGroup.planarUIAlwaysBehind

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

            sphere.addChild(box)
            root.addChild(sphere)
            content.add(root)

            subscriptions.append(content.subscribe(to: ManipulationEvents.WillEnd.self)  { event in
                updateBoxPosition(for: selectedSpace)
            })

            handleSpace(selectedSpace)
        }
        .onChange(of: sphere.observable.position, { oldValue, newValue in
            // Without this listener, the text views won't update when the sphere gets moved via manipulation
        })
        .ornament(attachmentAnchor: .scene(.topBack)) {
            ornamentUI
        }
        .preferredWindowClippingMargins(.all, 1000)
    }

    @ViewBuilder
    var ornamentUI: some View {
        VStack(alignment: .leading, spacing: 10) {
            spacePicker

            VectorDisplay(title: "Box Position World", vector: sphere.convert(position: box.observable.position, to: nil))
            VectorDisplay(title: "Box Position Local", vector: box.observable.position)
            VectorDisplay(title: "Box Position Object", vector: sphere.convert(position: box.observable.position, to: box))

            Divider()

            BoxPositionSliders(
                boxPosition: $boxPosition,
                selectedSpace: selectedSpace,
                box: box,
                boxObjectOrigin: $boxObjectOrigin
            ) {
                updateBoxPosition(for: selectedSpace)
            }
        }
        .padding(.horizontal, 40)
        .padding(.vertical)
        .glassBackgroundEffect()
    }

    var spacePicker: some View {
        HStack {
            Text("Space")
                .fontWeight(.bold)

            Spacer()

            Picker("Space", selection: $selectedSpace) {
                ForEach(SelectableCoordinateSpace.allCases) { space in
                    Text(space.rawValue)
                        .tag(space as SelectableCoordinateSpace)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: selectedSpace) { oldValue, newValue in
                handleSpace(newValue)
            }
        }
    }

    func setupRoot() {
        root.components.set(DrawComponent(showAxes: true))
        root.components.set(DrawRuntimeComponent())

        let spaceLabel = Entity(components: [ViewAttachmentComponent(rootView: Text("World").font(.largeTitle)), BillboardComponent()])
        spaceLabel.position.y = -0.035
        root.addChild(spaceLabel)
    }

    func setupSphere() {
        var material = UnlitMaterial(color: .cyan)
        material.blending = .transparent(opacity: PhysicallyBasedMaterial.Opacity(floatLiteral: 0.8))

        sphere = ModelEntity(
            mesh: .generateSphere(radius: 0.015),
            materials: [material])
        sphere.name = "Sphere"
        sphere.position = [0.1, 0.1, 0.1]
        sphere.orientation = simd_quatf(angle: -.pi / 2, axis: [0, 1, 0])

        var manipulationComponent = ManipulationComponent()
        manipulationComponent.releaseBehavior = .stay
        manipulationComponent.dynamics.scalingBehavior = .none
        manipulationComponent.dynamics.inertia = .zero
        sphere.components.set(manipulationComponent)
        sphere.generateCollisionShapes(recursive: true)
        sphere.components.set(InputTargetComponent())
        sphere.components.set(HoverEffectComponent())
        sphere.components.set(DrawComponent(showAxes: true))
        sphere.components.set(DrawRuntimeComponent())

        let spaceLabel = Entity(components: [ViewAttachmentComponent(rootView: Text("Local (Object Parent)").font(.largeTitle)), BillboardComponent()])
        spaceLabel.position.y = -0.035
        sphere.addChild(spaceLabel)
    }

    func setupBox() {
        var material = UnlitMaterial(color: .orange)
        material.blending = .transparent(opacity: PhysicallyBasedMaterial.Opacity(floatLiteral: 0.8))

        box = ModelEntity(
            mesh: .generateBox(size: 0.03),
            materials: [material])
        box.name = "Box"
        box.position = boxPosition
        box.orientation = simd_quatf(angle: .pi / 2, axis: [0, 1, 0])

        var manipulationComponent = ManipulationComponent()
        manipulationComponent.releaseBehavior = .stay
        manipulationComponent.dynamics.scalingBehavior = .none
        manipulationComponent.dynamics.inertia = .zero
        box.components.set(manipulationComponent)
        box.generateCollisionShapes(recursive: true)
        box.components.set(InputTargetComponent())
        box.components.set(HoverEffectComponent())
        box.components.set(DrawComponent(showAxes: true))
        box.components.set(DrawRuntimeComponent())

        let spaceLabel = Entity(components: [ViewAttachmentComponent(rootView: Text("Object").font(.largeTitle)), BillboardComponent()])
        spaceLabel.position.y = -0.035
        box.addChild(spaceLabel)
    }

    func handleSpace(_ space: SelectableCoordinateSpace) {
        updateBoxPosition(for: space)
    }

    func updateBoxPosition(for space: SelectableCoordinateSpace) {
        switch space {
        case .world:
            boxPosition = box.position(relativeTo: nil)
        case .local:
            boxPosition = box.position
        case .object:
            boxPosition = box.position(relativeTo: box)
            boxObjectOrigin = Transform(matrix: box.transformMatrix(relativeTo: nil)).translation
        }
    }

    func setupModelSorting() {
        root.drawRuntimeComponent?.axes?.components.set(ModelSortGroupComponent(group: modelSortGroup, order: 0))
        sphere.components.set(ModelSortGroupComponent(group: modelSortGroup, order: 0))
        box.components.set(ModelSortGroupComponent(group: modelSortGroup, order: 0))
    }
}

#Preview(windowStyle: .volumetric) {
    Lab002()
}

struct PositionSlider: View {
    var label: String
    @Binding var value: Float
    var range: ClosedRange<Float> = -2...2
    var onValueChange: (Float) -> Void
    var onEditingEnd: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(label)
                    .fontWeight(.bold)
                Text(String(format: "%.3f", value))
            }

            Slider(
                value: $value,
                in: range,
                onEditingChanged: { editing in
                    if !editing {
                        onEditingEnd?()
                    }
                }
            )
            .onChange(of: value) { oldValue, newValue in
                onValueChange(newValue)
            }
        }
    }
}

enum Axis {
    case x
    case y
    case z
}

struct BoxPositionSliders: View {
    @Binding var boxPosition: SIMD3<Float>
    var selectedSpace: SelectableCoordinateSpace
    var box: Entity
    @Binding var boxObjectOrigin: SIMD3<Float>
    var onEditingEnd: (() -> Void)? = nil

    var body: some View {
        VStack {
            PositionSlider(label: "Box X Position", value: $boxPosition.x) { newX in
                updateBoxPosition(axis: .x, newValue: newX)
            } onEditingEnd: {
                onEditingEnd?()
            }

            PositionSlider(label: "Box Y Position", value: $boxPosition.y) { newY in
                updateBoxPosition(axis: .y, newValue: newY)
            } onEditingEnd: {
                onEditingEnd?()
            }

            PositionSlider(label: "Box Z Position", value: $boxPosition.z) { newZ in
                updateBoxPosition(axis: .z, newValue: newZ)
            } onEditingEnd: {
                onEditingEnd?()
            }
        }
    }

    private func updateBoxPosition(axis: Axis, newValue: Float) {
        switch selectedSpace {
        case .world:
            var newPos = boxPosition
            switch axis {
            case .x: newPos.x = newValue
            case .y: newPos.y = newValue
            case .z: newPos.z = newValue
            }
            box.setPosition([newPos.x, newPos.y, newPos.z], relativeTo: nil)

        case .local:
            switch axis {
            case .x: box.position.x = newValue
            case .y: box.position.y = newValue
            case .z: box.position.z = newValue
            }

        case .object:
            var t = Transform(matrix: box.transformMatrix(relativeTo: nil))
            let localAxis: SIMD3<Float>
            switch axis {
            case .x: localAxis = t.rotation.act(SIMD3<Float>(1, 0, 0))
            case .y: localAxis = t.rotation.act(SIMD3<Float>(0, 1, 0))
            case .z: localAxis = t.rotation.act(SIMD3<Float>(0, 0, 1))
            }
            t.translation = boxObjectOrigin + localAxis * newValue
            box.setTransformMatrix(t.matrix, relativeTo: nil)
        }
    }
}
