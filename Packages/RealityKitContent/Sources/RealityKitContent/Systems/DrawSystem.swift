//
//  DrawSystem.swift
//  RealityKitContent
//
//  Created by Tempuno e.U. on 20.10.25.
//  Michael Temper: https://bsky.app/profile/michaeltemper.bsky.social
//

import OSLog
import Combine
import RealityKit

@MainActor
public struct DrawSystem: System {

    public static let query = EntityQuery(where: .has(DrawComponent.self))

    private var subscriptions = [Cancellable]()

    public init(scene: RealityKit.Scene) {
        subscriptions.append(scene.subscribe(to: ComponentEvents.DidAdd.self, componentType: DrawComponent.self, { event in
            if let drawComponent = event.entity.drawComponent {
                if event.entity.drawRuntimeComponent == nil {
                    event.entity.components.set(DrawRuntimeComponent())
                }

                if drawComponent.showAxes && event.entity.drawRuntimeComponent?.axes == nil {
                    event.entity.addAxes()
                }
            }
        }))
    }

    public func update(context: SceneUpdateContext) {
        for entity in context.entities(matching: Self.query, updatingSystemWhen: .rendering) where entity.isEnabled {
            guard let drawComponent = entity.drawComponent,
                  let drawRuntimeComponent = entity.drawRuntimeComponent else {
                continue
            }

            defer {
                entity.drawComponent = drawComponent
                entity.drawRuntimeComponent = drawRuntimeComponent
            }

            handleAxes(drawComponent: drawComponent, drawRuntimeComponent: drawRuntimeComponent)
            handleLines(entity: entity, drawComponent: drawComponent, drawRuntimeComponent: drawRuntimeComponent)
            handleSpheres(entity: entity, drawComponent: drawComponent, drawRuntimeComponent: drawRuntimeComponent)
            handleVectors(entity: entity, drawComponent: drawComponent, drawRuntimeComponent: drawRuntimeComponent)
        }
    }

    func handleAxes(drawComponent: DrawComponent, drawRuntimeComponent: DrawRuntimeComponent) {
        if let axes = drawRuntimeComponent.axes {
            if drawComponent.showAxes && !axes.isEnabled {
                drawRuntimeComponent.axes?.isEnabled = true
            } else if !drawComponent.showAxes && axes.isEnabled {
                drawRuntimeComponent.axes?.isEnabled = false
            }
        }
    }

    func handleLines(entity: Entity, drawComponent: DrawComponent, drawRuntimeComponent: DrawRuntimeComponent) {
        for var line in drawRuntimeComponent.lines {
            line.visualEntity?.isEnabled = line.isEnabled

            if line.isEnabled {
                if let startTarget = line.startTarget {
                    line.start = startTarget.position(relativeTo: nil)
                }

                if let endTarget = line.endTarget {
                    line.end = endTarget.position(relativeTo: nil)
                }

                let vector = line.end - line.start
                let length = length(vector)
                line.visualEntity?.scale.z = length
                line.visualEntity?.look(at: line.end, from: line.start + (vector / 2), relativeTo: entity.parent)

                if var material = line.visualEntity?.modelComponent?.materials.first as? UnlitMaterial, material.color.tint != line.color {
                    material.color.tint = line.color
                    line.visualEntity?.modelComponent?.materials = [material]
                }
            }
        }
    }

    func handleSpheres(entity: Entity, drawComponent: DrawComponent, drawRuntimeComponent: DrawRuntimeComponent) {
        for var sphere in drawRuntimeComponent.spheres {
            sphere.visualEntity?.isEnabled = sphere.isEnabled

            if sphere.isEnabled {
                if let target = sphere.target {
                    sphere.position = target.position(relativeTo: nil)
                }

                sphere.visualEntity?.setPosition(sphere.position, relativeTo: nil)
                sphere.visualEntity?.scale = .init(repeating: sphere.radius)

                if var material = sphere.visualEntity?.modelComponent?.materials.first as? UnlitMaterial, material.color.tint != sphere.color  {
                    material.color.tint = sphere.color
                    sphere.visualEntity?.modelComponent?.materials = [material]
                }
            }
        }
    }

    func handleVectors(entity: Entity, drawComponent: DrawComponent, drawRuntimeComponent: DrawRuntimeComponent) {
        for var vector in drawRuntimeComponent.vectors {
            vector.visualEntity?.isEnabled = vector.isEnabled

            if vector.isEnabled {
                if let startTarget = vector.startTarget {
                    vector.start = startTarget.position(relativeTo: nil)
                }

                if let endTarget = vector.endTarget {
                    vector.end = endTarget.position(relativeTo: nil)
                }

                let startToEndVector = vector.end - vector.start
                let length = length(startToEndVector)

                let shaft = vector.visualEntity?.children.first(where: { $0.name == Constants.shaft })
                shaft?.scale.z = length - 0.025 // Subtract the hardcoded end height for the correct length of the shaft
                shaft?.position.z = -length / 2 + 0.0125 // Offset half of hardcoded end height to place the shaft correctly between the origin and the end

                let end = vector.visualEntity?.children.first(where: { $0.name == Constants.end })
                end?.position.z = -length + 0.0125 // Offset half of hardcoded end height that the top of the end points at the vector end

                vector.visualEntity?.look(at: vector.end, from: vector.start, relativeTo: entity.parent)

                vector.visualEntity?.forEachDescendant(withComponent: ModelComponent.self) { entity, _ in
                    if var material = entity.modelComponent?.materials.first as? UnlitMaterial, material.color.tint != vector.color {
                        material.color.tint = vector.color
                        entity.modelComponent?.materials = [material]
                    }
                }
            }
        }
    }
}
