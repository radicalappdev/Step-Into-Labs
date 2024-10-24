//
//  File.swift
//  RealityKitContent
//
//  Created by Joseph Simpson on 10/24/24.
//

import Foundation
import RealityKit

// Added to teach myself ECS in visionOS starting with Lab 010
public struct BreathComponent: Component, Codable {

    public var duration: Float = 4.0

    public init() {

    }
}

