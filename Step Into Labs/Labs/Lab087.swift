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

    @State var nodes: Int = 9
    @State var previousNodes: Int = 3
    @State var arcDegrees: Double = 150
    @State var angleOffsetDegrees: Double = -90
    @State var shouldAutoCenter = true

    var body: some View {

        VStack {
            ArcLayout(angleOffset: .degrees(angleOffsetDegrees), degrees: arcDegrees, shouldAutoCenter: shouldAutoCenter) {
                ForEach(0..<nodes, id: \.self) { index in
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 400, height: 800)
                        .glassBackgroundEffect()
                        .rotation3DLayout(Rotation3D(angle: .degrees(360 - 90), axis: .x))
                }
            }
            .frame(width: 4800, height: 3600)
            .rotation3DLayout(Rotation3D(angle: .degrees(90), axis: .x))
            .transform3DEffect(AffineTransform3D(translation: Vector3D(x: 0, y: -2400, z: -2400)))
            .debugBorder3D(.white)
        }

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

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let updatedProposal = proposal.replacingUnspecifiedDimensions()
        let minDim = min(updatedProposal.width, updatedProposal.height)
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

        let minDimension = min(bounds.width, bounds.height)
        let subViewDim = minDimension / CGFloat((subviews.count / 2) + 1)
        let radius = min(bounds.width, bounds.height) / 2
        let placementRadius = radius - (subViewDim / 2)
        let center = CGPoint(x: bounds.midX, y: bounds.midY)

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

            let xPosition = center.x + (placementRadius * cos(angle))
            let yPosition = center.y + (placementRadius * sin(angle))

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
