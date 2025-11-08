//
//  Line.swift
//  RealityKitContent
//
//  Created by Tempuno e.U. on 20.10.25.
//  Michael Temper: https://bsky.app/profile/michaeltemper.bsky.social
//

import RealityKit
import UIKit

public struct Line {
    public var id: UUID = UUID()
    public var start: SIMD3<Float> = .zero
    public var end: SIMD3<Float> = .zero
    public var startTarget: Entity? = nil
    public var endTarget: Entity? = nil
    public var color: UIColor = .white
    public var isEnabled: Bool = true
    
    public var visualEntity: Entity? = nil
    
    public init(
        id: UUID = UUID(),
        start: SIMD3<Float> = .zero,
        end: SIMD3<Float> = .zero,
        startTarget: Entity? = nil,
        endTarget: Entity? = nil,
        color: UIColor = .white,
        isEnabled: Bool = true,
        visualEntity: Entity? = nil
    ) {
        self.id = id
        self.start = start
        self.end = end
        self.startTarget = startTarget
        self.endTarget = endTarget
        self.color = color
        self.isEnabled = isEnabled
        self.visualEntity = visualEntity
    }
}
