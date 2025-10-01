//  Step Into Vision - Labs
//
//  Title: Lab087
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 10/1/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab087: View {

    @State var nodes: Int = 7
    @State var previousNodes: Int = 3
    @State var arcDegrees: Double = 150
    @State var angleOffsetDegrees: Double = -90
    @State var shouldAutoCenter = true

    var body: some View {

        VStack {
            ArcLayout(angleOffset: .degrees(angleOffsetDegrees), degrees: arcDegrees, shouldAutoCenter: shouldAutoCenter, fitArcBoundingBox: true, verticalScale: 0.65) {
                ForEach(0..<nodes, id: \.self) { index in
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 400, height: 800)
                        .glassBackgroundEffect()
                        .rotation3DLayout(Rotation3D(angle: .degrees(360 - 90), axis: .x))
                        .rotation3DLayout(Rotation3D(angle: .degrees(inwardZRotation(for: index, total: nodes)), axis: .z))
                }
            }
            .debugBorder3D(.white)
            .frame(width: 3600, height: 4800)
            .frame(depth: 2400, alignment: .front)
            .rotation3DLayout(Rotation3D(angle: .degrees(90), axis: .x))
            .offset(y: -1200)
            .offset(z: -2400)

        }

    }

    // MARK: - Orientation helpers
    private func inwardZRotation(for index: Int, total: Int) -> Double {
        // Compute the placement angle used by ArcLayout for this index
        let angleDeg = arcPlacementAngleDegrees(for: index, total: total)
        // Rotate the card so its “top” points toward the circle center
        return angleDeg + 90.0
    }

    private func arcPlacementAngleDegrees(for index: Int, total: Int) -> Double {
        // Match ArcLayout’s math
        let arc = arcDegrees
        let startDeg = -90.0 // start from top
        let isFull = arc >= 359.9
        let incrementDeg: Double = {
            if isFull {
                return 360.0 / Double(max(1, total))
            } else {
                return arc / Double(max(1, total - 1))
            }
        }()

        // Auto-center offset (same as ArcLayout.autoCenterOffset)
        let offsetNeeded: Double = {
            guard shouldAutoCenter else { return 0 }
            let targetCenter = 0.0
            let arcCenter = startDeg + (arc / 2.0)
            return targetCenter - arcCenter
        }()

        return startDeg + (incrementDeg * Double(index)) + angleOffsetDegrees + offsetNeeded
    }
}

#Preview {
    Lab087()
}

// Adapted from the RadialLayout that Apple included in from Canyon Crosser from WWDC 2025
fileprivate struct ArcLayout: Layout, Animatable {
    var angleOffset: Angle = .zero
    var degrees: Double = 180 // Default to 180 degrees (half circle)
    var shouldAutoCenter: Bool = false // Whether to automatically center the arc
    var fitArcBoundingBox: Bool = true // If true, the layout reports/uses only the arc's bounding box instead of a full circle
    var verticalScale: CGFloat = 1.0 // 1.0 = circle, < 1.0 = shallower (ellipse)

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let updatedProposal = proposal.replacingUnspecifiedDimensions()
        let minDim = min(updatedProposal.width, updatedProposal.height)

        // If requested, size to the arc's bounding box rather than a full circle
        if fitArcBoundingBox {
            // For semicircles or smaller, height is approximately half the diameter
            if degrees <= 180 {
                return CGSize(width: minDim, height: (minDim / 2) * verticalScale)
            } else {
                // For larger arcs (180..360), linearly blend height from 0.5× to 1.0× of the diameter
                // so 180° -> 0.5×, 360° -> 1.0×.
                let t = min(max((degrees - 180.0) / 180.0, 0.0), 1.0)
                let height = (minDim * (0.5 + 0.5 * t)) * verticalScale
                return CGSize(width: minDim, height: height)
            }
        }

        // Default: full circle footprint
        return CGSize(width: minDim, height: minDim)
    }

    // Computed property to calculate auto-centering offset
    private var autoCenterOffset: Angle {
        guard shouldAutoCenter else { return .zero }

        // For auto-centering, we want the arc centered around 0° (horizontal center)
        let targetCenterAngle = 0.0
        let currentStartAngle = -90.0 // Our arc starts at -90° (top)
        let arcCenterAngle = currentStartAngle + (degrees / 2) // Current center of the arc
        let offsetNeeded = targetCenterAngle - arcCenterAngle

        return .degrees(offsetNeeded)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard subviews.count > 1 else {
            subviews[0].place(
                at: .init(x: bounds.midX, y: bounds.midY),
                anchor: .center,
                proposal: proposal)
            return
        }

        let subViewDim = min(bounds.width, bounds.height) / CGFloat((subviews.count / 2) + 1)

        // Use separate radii for an ellipse so spacing spreads across the full width
        let rx = (bounds.width / 2)  - (subViewDim / 2)   // horizontal (major) radius
        let ryBase = (bounds.height / 2) - (subViewDim / 2) // vertical (minor) radius
        // If we're not fitting to the arc's bounding box, apply the verticalScale here
        let ry = fitArcBoundingBox ? ryBase : (ryBase * verticalScale)
        let center: CGPoint
        if fitArcBoundingBox {
            if degrees <= 180 {
                // Place the circle's center on the bottom edge so a ≤180° arc occupies only the top half
                center = CGPoint(x: bounds.midX, y: bounds.maxY)
            } else {
                // Blend the center between bottom (for 180°) and middle (for 360°)
                let t = min(max((degrees - 180.0) / 180.0, 0.0), 1.0)
                let blendedY = bounds.maxY - (bounds.height * 0.5 * t)
                center = CGPoint(x: bounds.midX, y: blendedY)
            }
        } else {
            center = CGPoint(x: bounds.midX, y: bounds.midY)
        }

        // Convert degrees to radians and calculate angle increment for the arc
        let arcRadians = degrees * .pi / 180.0

        // For a full circle (360°), use radial layout logic
        // For partial arcs, span the specified degrees
        let angleIncrement: CGFloat
        let startRadians: CGFloat

        if degrees >= 359.9 { // Full circle - use original radial logic
            angleIncrement = 2 * .pi / CGFloat(subviews.count)
            startRadians = -.pi / 2 // Start from top (-90 degrees)
        } else { // Partial arc - span the specified degrees
            angleIncrement = arcRadians / CGFloat(max(1, subviews.count - 1))
            startRadians = -.pi / 2 // Start from top (-90 degrees)
        }

        for (index, subview) in subviews.enumerated() {
            // Calculate angle within the arc range
            let angle = startRadians + (angleIncrement * CGFloat(index)) + angleOffset.radians + autoCenterOffset.radians

            let xPosition = center.x + (rx * cos(angle))
            let yPosition = center.y + (ry * sin(angle))

            let point = CGPoint(x: xPosition, y: yPosition)
            subview.place(
                at: point, anchor: .center,
                proposal: .init(width: subViewDim, height: subViewDim))
        }
    }

    var animatableData: Angle.AnimatableData {
        get { angleOffset.animatableData }
        set { angleOffset.animatableData = newValue }
    }
}
