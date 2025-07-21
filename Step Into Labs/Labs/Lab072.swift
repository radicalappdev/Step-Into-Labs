//  Step Into Vision - Labs
//
//  Title: Lab072
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 7/21/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab072: View {

    @State var nodes: Int = 19
    @State private var showDebugLines = true

    var emoji: [String] = ["🌸", "🐸", "❤️", "🔥", "💻", "🐶", "🥸", "📱", "🎉", "🚀", "🤔", "🤓", "🧲", "💰", "🤩", "🍪", "🦉", "💡", "😎"]
    
    var body: some View {
        HoneycombLayout {
            ForEach(0..<nodes, id: \.self) { index in
                ModelViewEmoji(name: "UISphere01", emoji: emoji[index], bundle: realityKitContentBundle)
                    .rotation3DLayout(Rotation3D(angle: .degrees(-45), axis: .x))
                    .debugBorder3D(showDebugLines ? .white : .clear)
                    .manipulable()
                    .hoverEffect()
            }
        }
//        .frame(width: 600, height: 600)
        .rotation3DLayout(Rotation3D(angle: .degrees(45), axis: .x))
        .debugBorder3D(showDebugLines ? .white : .clear)
    }
}

fileprivate struct ModelViewEmoji: View {

    @State var name: String = ""
    let emoji: String
    let bundle: Bundle

    var body: some View {
        Model3D(named: name, bundle: bundle)
        { phase in
            if let model = phase.model {
                model
                    .resizable()
                    .frame(width: 96, height: 96)
                    .frame(depth: 96)
                    .aspectRatio(contentMode: .fill)
                    .spatialOverlay(alignment:  .center) {
                        Text(emoji)
                            .font(.system(size: 48))
                    }
            } else if phase.error != nil {
                Text(emoji) // just load the emoji without the model
            } else {
                ProgressView()
            }
        }
    }
}

// Honeycomb grid layout that grows from the inside out
// Cursor was very helpful for creating this layout. I gave it the RadialLayout as an example and described the structure I wanted. It took a few iterations, but the result is pretty neat.
fileprivate struct HoneycombLayout: Layout, Animatable {
    var angleOffset: Angle = .zero

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let updatedProposal = proposal.replacingUnspecifiedDimensions()
        let minDim = min(updatedProposal.width, updatedProposal.height)
        return CGSize(width: minDim, height: minDim)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard !subviews.isEmpty else { return }

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let hexSize: CGFloat = 124
        let hexRadius = hexSize / 2

        // Calculate hexagon spacing (distance between centers)
        let hexSpacing = hexRadius * sqrt(3) + 20

        // Generate hexagon positions in a spiral pattern
        var positions: [CGPoint] = []
        positions.append(center) // Center hexagon

        var ring = 1
        while positions.count < subviews.count {
            // For each ring, place hexagons at 60-degree intervals
            for i in 0..<6 {
                let angle = Double(i) * .pi / 3 + angleOffset.radians
                let radius = Double(ring) * hexSpacing
                let x = center.x + radius * cos(angle)
                let y = center.y + radius * sin(angle)
                positions.append(CGPoint(x: x, y: y))
            }

            // Fill in the gaps between the corners for larger rings
            if ring > 1 {
                for i in 0..<6 {
                    let startAngle = Double(i) * .pi / 3 + angleOffset.radians
                    let endAngle = Double(i + 1) * .pi / 3 + angleOffset.radians
                    let radius = Double(ring) * hexSpacing

                    // Add intermediate positions with adjusted radius for tighter honeycomb
                    for j in 1..<ring {
                        let angle = startAngle + (endAngle - startAngle) * Double(j) / Double(ring)

                        // Adjust radius for items that should be closer to center
                        // Items at the edges of each segment get pulled in slightly
                        let radiusAdjustment = 0.15 // Pull items in by 15%
                        let adjustedRadius = radius * (1.0 - radiusAdjustment)

                        let x = center.x + adjustedRadius * cos(angle)
                        let y = center.y + adjustedRadius * sin(angle)
                        positions.append(CGPoint(x: x, y: y))
                    }
                }
            }

            ring += 1
        }

        // Place subviews at calculated positions
        for (index, subview) in subviews.enumerated() {
            if index < positions.count {
                subview.place(
                    at: positions[index],
                    anchor: .center,
                    proposal: .init(width: hexSize, height: hexSize)
                )
            }
        }
    }

    var animatableData: Angle.AnimatableData {
        get { angleOffset.animatableData }
        set { angleOffset.animatableData = newValue }
    }
}
