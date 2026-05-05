//  Step Into Vision - Labs
//
//  Title: Lab103
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Featured:
//
//  Created by Joseph Simpson on 5/4/26.

import SwiftUI
@preconcurrency import RealityKit
import RealityKitContent

struct Lab103: View {
    @State private var updateSubscription: EventSubscription?
    @State private var frameCount = 0

    var body: some View {
        RealityView { content in
            guard let scene = try? await Entity(named: "CameraLab", in: realityKitContentBundle) else { return }
            guard let contentScene = scene.clone(recursive: true) as Entity?,
                  let monitorScene = scene.clone(recursive: true) as Entity? else { return }
            content.add(contentScene)

            let target = SIMD3<Float>(0, 1.25, -4)

            let camera = PerspectiveCamera()
            camera.name = "DemoCamera"
            camera.look(at: target, from: [0, 1.25, -1.2], relativeTo: nil)
            content.add(camera)

            let cameraHandle = ModelEntity(
                mesh: .generateSphere(radius: 0.08),
                materials: [SimpleMaterial(color: .orange, isMetallic: true)]
            )
            cameraHandle.position = [0, 0, 0.12]
            camera.addChild(cameraHandle)

            camera.components.set(ManipulationComponent())
            cameraHandle.components.set(ManipulationComponent.HitTarget(redirectedEntity: camera))
            ManipulationComponent.configureEntity(
                cameraHandle,
                collisionShapes: [.generateSphere(radius: 0.08)]
            )

            guard let monitorRenderer = try? RealityRenderer() else { return }

            let monitorCamera = PerspectiveCamera()
            monitorCamera.look(at: target, from: [0, 1.25, -1.2], relativeTo: nil)

            let monitorLight = DirectionalLight()
            monitorLight.look(at: target, from: [2, 6, 2], relativeTo: nil)
            monitorLight.light.intensity = 25_000

            let debugBox = ModelEntity(
                mesh: .generateBox(size: 0.35),
                materials: [UnlitMaterial(color: .cyan)]
            )
            debugBox.position = [0.8, 1.0, -3.2]
            
            monitorRenderer.entities.append(monitorScene)
            monitorRenderer.entities.append(monitorCamera)
            monitorRenderer.entities.append(monitorLight)
            monitorRenderer.entities.append(debugBox)

            monitorRenderer.activeCamera = monitorCamera
            monitorRenderer.cameraSettings.isToneMappingEnabled = true
            monitorRenderer.cameraSettings.colorBackground = .color(
                CGColor(red: 0, green: 1, blue: 0, alpha: 1)
            )

            let textureOptions = TextureResource.CreateOptions(
                semantic: .color,
                mipmapsMode: .none
            )
            let textureResource = try? await TextureResource(
                image: Self.placeholderImage(),
                options: textureOptions
            )

            let drawableDescriptor = TextureResource.DrawableQueue.Descriptor(
                pixelFormat: .bgra8Unorm,
                width: 1280,
                height: 720,
                usage: [.renderTarget, .shaderRead],
                mipmapsMode: .none
            )

            guard let textureResource,
                  let drawableQueue = try? TextureResource.DrawableQueue(drawableDescriptor) else { return }

            drawableQueue.allowsNextDrawableTimeout = false
            textureResource.replace(withDrawables: drawableQueue)

            let screen = ModelEntity(
                mesh: .generatePlane(width: 0.7, height: 0.4, cornerRadius: 0.02),
                materials: [UnlitMaterial(texture: textureResource)]
            )
            screen.position = [0, 1.1, -1.1]
            content.add(screen)

            let updateProbe = ModelEntity(
                mesh: .generateBox(size: 0.08),
                materials: [SimpleMaterial(color: .red, isMetallic: false)]
            )
            updateProbe.position = [-0.45, 1.1, -1.0]
            content.add(updateProbe)

            let renderProbe = ModelEntity(
                mesh: .generateBox(size: 0.08),
                materials: [SimpleMaterial(color: .red, isMetallic: false)]
            )
            renderProbe.position = [0.45, 1.1, -1.0]
            content.add(renderProbe)

            updateSubscription = content.subscribe(to: SceneEvents.Update.self) { event in
                monitorCamera.position = camera.position
                monitorCamera.orientation = camera.orientation

                Task { @MainActor in
                    frameCount += 1

                    let phase = frameCount.isMultiple(of: 30)
                    updateProbe.position.y = phase ? 1.18 : 1.02
                    updateProbe.model?.materials = [
                        SimpleMaterial(color: phase ? .green : .red, isMetallic: false)
                    ]
                    
                    guard let drawable = try? drawableQueue.nextDrawable() else {
                        renderProbe.model?.materials = [
                            SimpleMaterial(color: .yellow, isMetallic: false)
                        ]
                        return
                    }

                    let descriptor = RealityRenderer.CameraOutput.Descriptor.singleProjection(
                        colorTexture: drawable.texture
                    )

                    guard let cameraOutput = try? RealityRenderer.CameraOutput(descriptor) else {
                        renderProbe.model?.materials = [
                            SimpleMaterial(color: .orange, isMetallic: false)
                        ]
                        drawable.present()
                        return
                    }

                    do {
                        try monitorRenderer.updateAndRender(
                            deltaTime: event.deltaTime,
                            cameraOutput: cameraOutput,
                            onComplete: { _ in
                                Task { @MainActor in
                                    drawable.presentOnSceneUpdate()
                                }
                            }
                        )

                        renderProbe.position.y = 1.18
                        renderProbe.model?.materials = [
                            SimpleMaterial(color: .green, isMetallic: false)
                        ]
                    } catch {
                        print("Lab103 offscreen render error:", String(reflecting: error))
                        drawable.present()
                        renderProbe.position.y = 1.02
                        renderProbe.model?.materials = [
                            SimpleMaterial(color: .purple, isMetallic: false)
                        ]
                    }
                }
            }
        }
    }
}

#Preview {
    Lab103()
}

private extension Lab103 {
    static func placeholderImage() throws -> CGImage {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: nil,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            throw PlaceholderImageError.contextCreationFailed
        }

        context.setFillColor(CGColor(gray: 0, alpha: 1))
        context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))

        guard let image = context.makeImage() else {
            throw PlaceholderImageError.imageCreationFailed
        }

        return image
    }
}

private enum PlaceholderImageError: Error {
    case contextCreationFailed
    case imageCreationFailed
}
