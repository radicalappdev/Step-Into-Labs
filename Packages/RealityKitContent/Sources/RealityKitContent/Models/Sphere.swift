//
//  Sphere.swift
//  RealityKitContent
//
//  Created by Tempuno e.U. on 20.10.25.
//  Michael Temper: https://bsky.app/profile/michaeltemper.bsky.social
//

import RealityKit
import UIKit

public struct Sphere {
    public var id: UUID = UUID()
    public var radius: Float = .zero
    public var position: SIMD3<Float> = .zero
    public var target: Entity? = nil
    public var color: UIColor = .white
    public var isEnabled: Bool = true
    
    public var visualEntity: Entity? = nil
    
    public init(
        id: UUID = UUID(),
        radius: Float,
        position: SIMD3<Float> = .zero,
        target: Entity? = nil,
        color: UIColor = .white,
        isEnabled: Bool = true,
        visualEntity: Entity? = nil
    ) {
        self.id = id
        self.radius = radius
        self.position = position
        self.target = target
        self.color = color
        self.isEnabled = isEnabled
        self.visualEntity = visualEntity
    }
}
