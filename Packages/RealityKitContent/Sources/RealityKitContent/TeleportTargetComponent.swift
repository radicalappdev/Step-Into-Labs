//
//  File.swift
//  RealityKitContent
//
//  Created by Joseph Simpson on 2/19/25.
//

import Foundation
@preconcurrency import RealityKit

// Added to teach myself ECS in visionOS starting with Lab 010
public struct TeleportTargetComponent: Component, Codable {

    public enum TargetType: String, Codable {
        case waypoint
        case viewpoint

    }

    /// The type of telepotation to perform
    public var targetType: TargetType = .waypoint



    public init() {

    }
}
