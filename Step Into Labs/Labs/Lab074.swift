//  Step Into Vision - Labs
//
//  Title: Lab074
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 7/30/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab074: View {
    var body: some View {
        VStack {

            RadialLayout(angleOffset: .degrees(0)) {
                ForEach(0..<59, id: \.self) { index in
                    Text("•")
                        .id(index)
                }
            }
            .padding(.vertical, 20)
        }
    }
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
