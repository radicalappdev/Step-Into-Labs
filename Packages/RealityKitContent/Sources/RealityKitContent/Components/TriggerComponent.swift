//
//  TriggerComponent.swift
//  RealityKitContent
//
//  Created by Tempuno e.U. on 20.10.25.
//  Michael Temper: https://bsky.app/profile/michaeltemper.bsky.social
//

import Foundation
import RealityKit

public struct TriggerComponent: Component, Codable {
    public var radius: Float = .zero
    public var isTriggered: Bool = false
    
    public init(radius: Float, isTriggered: Bool = false) {
        self.radius = radius
        self.isTriggered = isTriggered
    }
}

public struct TriggerRuntimeComponent: Component {
    public var target: Entity

    public init(target: Entity) {
        self.target = target
    }
}
