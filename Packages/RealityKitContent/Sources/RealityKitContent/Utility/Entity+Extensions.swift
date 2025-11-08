//
//  EntityExtensions.swift
//
//
//  Created by Tempuno e.U. on 20.10.25.
//

import OSLog
import UIKit
import RealityKit
import SwiftUI

public extension Entity {
    
    /// Recursive search of children looking for any descendants with a specific component and calling a closure with them.
    func forEachDescendant<T: Component>(withComponent componentClass: T.Type, includingSelf: Bool = false, _ closure: (Entity, T) -> Void) {
        if includingSelf, let component = components[componentClass] {
            closure(self, component)
        }
        
        for child in children {
            if let component = child.components[componentClass] {
                closure(child, component)
            }
            child.forEachDescendant(withComponent: componentClass, includingSelf: false, closure)
        }
    }
    
    func forEachDescendant(includingSelf: Bool = false, _ closure: (Entity) -> Void) {
        if includingSelf {
            closure(self)
        }
        
        for child in children {
            closure(child)
            child.forEachDescendant(includingSelf: false, closure)
        }
    }
    
    static func getSphere(radius: Float = 0.1,
                          color: UIColor = .orange,
                          material: RealityKit.Material? = nil,
                          collisionEnabled: Bool = true,
                          inputEnabled: Bool = true,
                          mass: Float = 0) -> ModelEntity {
        let sphere = ModelEntity(mesh: .generateSphere(radius: radius),
                           materials: [material ?? UnlitMaterial(color: color)],
                           collisionShapes: collisionEnabled || inputEnabled ? [.generateSphere(radius: radius)] : [],
                           mass: mass)
        
        if inputEnabled {
            sphere.components.set(InputTargetComponent())
        }
        
        return sphere
    }
    
    static func getBox(size: Float = 0.1,
                       color: UIColor = .red,
                       material: RealityKit.Material? = nil,
                       collisionEnabled: Bool = true,
                       inputEnabled: Bool = true,
                       mass: Float = 0) -> ModelEntity {
        let sizeVector = SIMD3<Float>(repeating: size)
        return getBox(size: sizeVector,
                      color: color,
                      material: material,
                      collisionEnabled: collisionEnabled,
                      inputEnabled: inputEnabled,
                      mass: mass)
    }
    
    static func getBox(size: SIMD3<Float> = .init(repeating: 0.1),
                       color: UIColor = .red,
                       material: RealityKit.Material? = nil,
                       collisionEnabled: Bool = true,
                       inputEnabled: Bool = true,
                       mass: Float = 0) -> ModelEntity {
        let box = ModelEntity(mesh: .generateBox(size: size),
                              materials: [material ?? UnlitMaterial(color: color)],
                              collisionShapes: collisionEnabled || inputEnabled ? [.generateBox(size: size)] : [],
                              mass: mass)
        if inputEnabled {
            box.components.set(InputTargetComponent())
        }
        
        return box
    }
    
    func addAxes() {
        guard drawRuntimeComponent?.axes == nil else {
            print("Axes already exist!")
            return
        }
        
        let axes = Entity.createAxes()
        drawRuntimeComponent?.axes = axes
        addChild(axes)
    }
    
    static func createAxes() -> Entity {
        let size: Float = 0.01
        let height: Float = 0.25
        
        let xAxis = createArrow(size: size, height: height, color: .red, opacity: 1)
        let yAxis = createArrow(size: size, height: height, color: .green, opacity: 1)
        let zAxis = createArrow(size: size, height: height, color: .blue, opacity: 1)
        
        xAxis.name = Constants.xAxis
        yAxis.name = Constants.yAxis
        zAxis.name = Constants.zAxis
        
        xAxis.orientation = simd_quatf(angle: -.pi / 2, axis: [0, 1, 0])
        yAxis.orientation = simd_quatf(angle: .pi / 2, axis: [1, 0, 0])
        zAxis.orientation = simd_quatf(angle: .pi, axis: [0, 1, 0])
        
        let axes = Entity()
        axes.name = Constants.axes
        
        axes.addChild(xAxis)
        axes.addChild(yAxis)
        axes.addChild(zAxis)
        
        return axes
    }
    
    static private func createArrow(size: Float, height: Float, color: UIColor = .white, opacity: Float = 1) -> Entity {
        let arrow = Entity()
        
        var material = UnlitMaterial(color: color)
        material.blending = .transparent(opacity: PhysicallyBasedMaterial.Opacity(floatLiteral: opacity))
        
        let shaft = ModelEntity(mesh: .generateBox(width: size / 2,
                                                   height: size / 2,
                                                   depth: height),
                                materials: [material])
        shaft.name = Constants.shaft
        
        let endHeight: Float = 0.025
        let end = ModelEntity(mesh: .generateCone(height: endHeight,
                                                  radius: 0.01),
                              materials: [material])
        end.name = Constants.end
        
        end.orientation = simd_quatf(angle: -.pi / 2, axis: [1, 0, 0])

        arrow.addChild(shaft)
        arrow.addChild(end)
        
        shaft.scale.z = 1 - (0.025 / height)
        shaft.position.z = -height / 2 + 0.0125
        
        end.position.z = -height + endHeight * 0.5
        
        return arrow
    }
    
    @discardableResult
    func addLine(from start: SIMD3<Float>, to end: SIMD3<Float>, color: UIColor = .white, opacity: Float = 0.2) -> Line? {
        guard var drawRuntimeComponent else {
            print("No DrawRuntimeComponent set!")
            return nil
        }
        
        defer {
            self.drawRuntimeComponent = drawRuntimeComponent
        }
        
        var material = UnlitMaterial(color: color)
        material.blending = .transparent(opacity: PhysicallyBasedMaterial.Opacity(floatLiteral: opacity))
        
        // (Model-)Entity creation can be performance heavy. Therefore, we create a Unit Line with a fixed length of one for the z-axis.
        // Then we can simply adjust it's length via the z-scale.
        let modelEntity = ModelEntity(mesh: .generateBox(width: 0.005, height: 0.005, depth: 1), materials: [material])
        let line = Line(start: start, end: end, color: color, visualEntity: modelEntity)
        drawRuntimeComponent.lines.append(line)
        
        addChild(modelEntity)
        
        return line
    }
    
    @discardableResult
    func addLine(from startTarget: Entity, to endTarget: Entity, color: UIColor = .white, opacity: Float = 0.2) -> Line? {
        guard var drawRuntimeComponent else {
            print("No DrawRuntimeComponent set!")
            return nil
        }
        
        defer {
            self.drawRuntimeComponent = drawRuntimeComponent
        }
        
        var material = UnlitMaterial(color: color)
        material.blending = .transparent(opacity: PhysicallyBasedMaterial.Opacity(floatLiteral: opacity))
        
        // (Model-)Entity creation can be performance heavy. Therefore, we create a Unit Line with a fixed length of one for the z-axis.
        // Then we can simply adjust it's length via the z-scale.
        let modelEntity = ModelEntity(mesh: .generateBox(width: 0.005, height: 0.005, depth: 1), materials: [material])
        let line = Line(startTarget: startTarget, endTarget: endTarget, color: color, visualEntity: modelEntity)
        drawRuntimeComponent.lines.append(line)
        
        addChild(modelEntity)
        
        return line
    }
    
    @discardableResult
    func addVector(from start: SIMD3<Float>, to end: SIMD3<Float>, color: UIColor = .white, opacity: Float = 1) -> Vector? {
        guard var drawRuntimeComponent else {
            print("No DrawRuntimeComponent set!")
            return nil
        }
        
        defer {
            self.drawRuntimeComponent = drawRuntimeComponent
        }
        
        // (Model-)Entity creation can be performance heavy. Therefore, we create a Unit Line with a fixed length of one for the z-axis.
        // Then we can simply adjust it's length via the z-scale.
        let modelEntity = Entity.createArrow(size: 0.005, height: 1, opacity: opacity)
        let line = Vector(start: start, end: end, color: color, visualEntity: modelEntity)
        drawRuntimeComponent.vectors.append(line)
        
        addChild(modelEntity)
        
        return line
    }
    
    @discardableResult
    func addVector(from startTarget: Entity, to endTarget: Entity, color: UIColor = .white, opacity: Float = 1) -> Vector? {
        guard var drawRuntimeComponent else {
            print("No DrawRuntimeComponent set!")
            return nil
        }
        
        defer {
            self.drawRuntimeComponent = drawRuntimeComponent
        }
        
        // (Model-)Entity creation can be performance heavy. Therefore, we create a Unit Line with a fixed length of one for the z-axis.
        // Then we can simply adjust it's length via the z-scale.
        let modelEntity = Entity.createArrow(size: 0.005, height: 1, opacity: opacity)
        let line = Vector(startTarget: startTarget, endTarget: endTarget, color: color, visualEntity: modelEntity)
        drawRuntimeComponent.vectors.append(line)
        
        addChild(modelEntity)
        
        return line
    }
    
    @discardableResult
    func addSphere(to position: SIMD3<Float>, radius: Float, color: UIColor = .white, opacity: Float = 0.2) -> Sphere? {
        guard var drawRuntimeComponent else {
            print("No DrawRuntimeComponent set!")
            return nil
        }
        
        defer {
            self.drawRuntimeComponent = drawRuntimeComponent
        }
        
        var material = UnlitMaterial(color: color)
        material.blending = .transparent(opacity: PhysicallyBasedMaterial.Opacity(floatLiteral: opacity))
    
        // (Model-)Entity creation can be performance heavy. Therefore, we create a Unit Sphere with a fixed radius of one.
        // Then we can simply adjust it's size via the scale.
        let modelEntity = ModelEntity(mesh: .generateSphere(radius: 1), materials: [material])
        let sphere = Sphere(radius: radius, position: position, visualEntity: modelEntity)
        drawRuntimeComponent.spheres.append(sphere)
        
        addChild(modelEntity)
        
        return sphere
    }
    
    @discardableResult
    func addSphere(to target: Entity, radius: Float, color: UIColor = .white, opacity: Float = 0.2) -> Sphere? {
        guard var drawRuntimeComponent else {
            print("No DrawRuntimeComponent set!")
            return nil
        }
        
        defer {
            self.drawRuntimeComponent = drawRuntimeComponent
        }
        
        var material = UnlitMaterial(color: color)
        material.blending = .transparent(opacity: PhysicallyBasedMaterial.Opacity(floatLiteral: opacity))
    
        // (Model-)Entity creation can be performance heavy. Therefore, we create a Unit Sphere with a fixed radius of one.
        // Then we can simply adjust it's size via the scale.
        let modelEntity = ModelEntity(mesh: .generateSphere(radius: 1), materials: [material])
        let sphere = Sphere(radius: radius, target: target, visualEntity: modelEntity)
        drawRuntimeComponent.spheres.append(sphere)
        
        addChild(modelEntity)
        
        return sphere
    }
    
    // MARK: - Sphere Helpers
    func updateSphere(with id: UUID, update: (inout Vector) -> Void) {
        drawRuntimeComponent?.updateVector(with: id, update: update)
    }
    
    func updateSphere(with id: UUID?, update: (inout Sphere) -> Void) {
        drawRuntimeComponent?.updateSphere(with: id, update: update)
    }
    
    func sphere(with id: UUID) -> Sphere? {
        drawRuntimeComponent?.spheres.first(where: { $0.id == id })
    }
    
    func sphere(with id: UUID?) -> Sphere? {
        guard let id else { return nil }
        return sphere(with: id)
    }
    
    // MARK: - Vector Helpers

    func updateVector(with id: UUID, update: (inout Vector) -> Void) {
        drawRuntimeComponent?.updateVector(with: id, update: update)
    }
    
    func updateVector(with id: UUID?, update: (inout Vector) -> Void) {
        drawRuntimeComponent?.updateVector(with: id, update: update)
    }
    
    func vector(with id: UUID) -> Vector? {
        drawRuntimeComponent?.vectors.first(where: { $0.id == id })
    }
    
    func vector(with id: UUID?) -> Vector? {
        guard let id else { return nil }
        return vector(with: id)
    }
}

public extension Entity {
    
    var drawComponent: DrawComponent? {
        get { components[DrawComponent.self] }
        set { components[DrawComponent.self] = newValue }
    }
    
    var drawRuntimeComponent: DrawRuntimeComponent? {
        get { components[DrawRuntimeComponent.self] }
        set { components[DrawRuntimeComponent.self] = newValue }
    }
    
    var modelComponent: ModelComponent? {
        get { components[ModelComponent.self] }
        set { components[ModelComponent.self] = newValue }
    }
    
    var modelSortGroupComponent: ModelSortGroupComponent? {
        get { components[ModelSortGroupComponent.self] }
        set { components[ModelSortGroupComponent.self] = newValue }
    }
    
    var triggerComponent: TriggerComponent? {
        get { components[TriggerComponent.self] }
        set { components[TriggerComponent.self] = newValue }
    }
    
    var triggerRuntimeComponent: TriggerRuntimeComponent? {
        get { components[TriggerRuntimeComponent.self] }
        set { components[TriggerRuntimeComponent.self] = newValue }
    }
    
    var viewAttachmentComponent: ViewAttachmentComponent? {
        get { components[ViewAttachmentComponent.self] }
        set { components[ViewAttachmentComponent.self] = newValue }
    }
}
