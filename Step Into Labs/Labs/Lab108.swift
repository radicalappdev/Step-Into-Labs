//  Step Into Vision - Labs
//
//  Title: Lab108
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Featured:
//
//  Created by Joseph Simpson on 5/11/26.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab108: View {
    @State private var activeSceneIndex = 0

    private let sceneNames = ["Vapor", "Mist", "Droplet"]

    var body: some View {
        RealityView { content in

            guard let vapor = try? await Entity(named: "Vapor", in: realityKitContentBundle) else { return }
            vapor.name = "Vapor"
            await configurePortal(on: vapor, contentName: "Mist")
            content.add(vapor)

            guard let mist = try? await Entity(named: "Mist", in: realityKitContentBundle) else { return }
            mist.name = "Mist"
            mist.isEnabled = false
            await configurePortal(on: mist, contentName: "Droplet")
            content.add(mist)

            guard let droplet = try? await Entity(named: "Droplet", in: realityKitContentBundle) else { return }
            droplet.name = "Droplet"
            droplet.isEnabled = false
            await configurePortal(on: droplet, contentName: "DropletInner", allowsCrossing: true)
            content.add(droplet)
        } update: { content in
            for (index, sceneName) in sceneNames.enumerated() {
                content.entities.first { $0.name == sceneName }?.isEnabled = index == activeSceneIndex
            }
        }
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(3))
                activeSceneIndex = (activeSceneIndex + 1) % sceneNames.count
            }
        }
    }

    private func configurePortal(
        on rootEntity: Entity,
        contentName: String,
        allowsCrossing: Bool = false
    ) async {
        let portalContentRoot = Entity()
        portalContentRoot.components.set(WorldComponent())
        rootEntity.addChild(portalContentRoot)

        if let screenSurface = rootEntity.findEntity(named: "ScreenSurface") {
            var portalMaterial = PortalMaterial()
            portalMaterial.faceCulling = .none

            if var modelComponent = screenSurface.components[ModelComponent.self] {
                modelComponent.materials = modelComponent.materials.map { _ in portalMaterial }
                screenSurface.components.set(modelComponent)
                screenSurface.components.set(PortalComponent(
                    target: portalContentRoot,
                    clippingMode: .plane(.negativeY),
                    crossingMode: allowsCrossing ? .plane(.negativeY) : .disabled
                ))
            }
        }

        guard let portalScene = try? await Entity(named: contentName, in: realityKitContentBundle) else { return }

        if allowsCrossing {
            portalScene.components.set(PortalCrossingComponent())
        } else {
            portalScene.scale = .init(repeating: 0.5)
            portalScene.position = [0, 4, -9]
            portalScene.orientation = simd_quatf(angle: -6, axis: [1, 0, 0])
        }

        portalContentRoot.addChild(portalScene)
    }
}

#Preview {
    Lab108()
}
