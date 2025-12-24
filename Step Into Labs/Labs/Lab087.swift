//  Step Into Vision - Labs
//
//  Title: Lab087
//
//  Subtitle: Standing inside a Spatial Layout
//
//  Description: Documenting a workaround for using SwiftUI Spatial Layouts in Immersive Spaces.
//
//  Type: Space
//
//  Featured: false
//
//  Created by Joseph Simpson on 10/1/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab087: View {

    @State private var angleOffset: Angle = .zero

    @State var nodes: Int = 12
    @State var previousNodes: Int = 3
    @State var arcDegrees: Double = 360
    @State var angleOffsetDegrees: Double = -90
    @State var shouldAutoCenter = true

    var body: some View {

        VStack {
            RadialLayout(angleOffset: angleOffset) {
                ForEach(0..<nodes, id: \.self) { index in
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 500, height: 800)
                        .glassBackgroundEffect()
                        .rotation3DLayout(Rotation3D(angle: .degrees(360 - 90), axis: .x))
                        .rotation3DLayout(Rotation3D(angle: .degrees(inwardZRotation(for: index, total: nodes)), axis: .z))
                        .offset(z: -1200)
                }
            }
            .debugBorder3D(.white)
            .frame(width: 3600, height: 3600)
            .frame(depth: 3600, alignment: .front)
            .rotation3DLayout(Rotation3D(angle: .degrees(90), axis: .x))
            .offset(y: -1800)
            .offset(z: -1200)

        }

    }

    // Some helper functions to Orient each card towards the center (WIP)
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

// Taken from Canyon Crosser from WWDC 2025
// For information on custom layouts, watch https://developer.apple.com/videos/play/wwdc2022/10056.
fileprivate struct RadialLayout: Layout, Animatable {
    var angleOffset: Angle = .zero

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let updatedProposal = proposal.replacingUnspecifiedDimensions()
        let minDim = min(updatedProposal.width, updatedProposal.height)
        return CGSize(width: minDim, height: minDim)
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
        let angleIncrement = 2 * .pi / CGFloat(subviews.count)
        let centerOffset = Double.pi / 2 // Centers the view.

        for (index, subview) in subviews.enumerated() {
            let angle = angleIncrement * CGFloat(index) + angleOffset.radians + centerOffset

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

