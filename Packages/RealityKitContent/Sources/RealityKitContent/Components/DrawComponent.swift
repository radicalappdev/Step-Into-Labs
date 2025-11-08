//
//  DrawComponent.swift
//  RealityKitContent
//
//  Created by Tempuno e.U. on 20.10.25.
//  Michael Temper: https://bsky.app/profile/michaeltemper.bsky.social
//

import Foundation
import RealityKit

public struct DrawComponent: Component, Codable {
    public var showAxes: Bool = false

    public init(showAxes: Bool = false) {
        self.showAxes = showAxes
    }
}

public struct DrawRuntimeComponent: Component {
    public var axes: Entity? = nil

    public var lines: [Line] = []
    public var spheres: [Sphere] = []
    public var vectors: [Vector] = []

    public init(
        axes: Entity? = nil,
        lines: [Line] = [],
        spheres: [Sphere] = [],
        vectors: [Vector] = []
    ) {
        self.axes = axes
        self.lines = lines
        self.spheres = spheres
        self.vectors = vectors
    }

    public mutating func updateSphere(
        with id: UUID,
        update: (inout Sphere) -> Void
    ) {
        guard let index = spheres.firstIndex(where: { $0.id == id }) else { return }
        update(&spheres[index])
    }

    public mutating func updateSphere(with id: UUID?, update: (inout Sphere) -> Void) {
        guard let id else { fatalError("No ID found for vector!") }
        updateSphere(with: id, update: update)
    }

    private func sphere(with id: UUID) -> Sphere? {
        spheres.first(where: { $0.id == id })
    }

    public mutating func updateVector(
        with id: UUID,
        update: (inout Vector) -> Void
    ) {
        guard let index = vectors.firstIndex(where: { $0.id == id }) else { return }
        update(&vectors[index])
    }

    public mutating func updateVector(with id: UUID?, update: (inout Vector) -> Void) {
        guard let id else { fatalError("No ID found for vector!") }
        updateVector(with: id, update: update)
    }

    private func vector(with id: UUID) -> Vector? {
        vectors.first(where: { $0.id == id })
    }
}
