//  Step Into Vision - Labs
//
//  Title: Lab068
//
//  Subtitle: Adding an axis to custom layouts
//
//  Description: Building on the custom layouts from Lab 067, we can add some 3D models and use SwiftUI modifiers to control rotation and position.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 7/16/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab068: View {

    @State var nodes: Int = 3
    @State var previousNodes: Int = 3
    @State var useHoneycomb: Bool = false

    var emoji: [String] = ["🌸", "🐸", "❤️", "🔥", "💻", "🐶", "🥸", "📱", "🎉", "🚀", "🤔", "🤓", "🧲", "💰", "🤩", "🍪", "🦉", "💡", "😎"]

    var body: some View {

        VStack {
            if useHoneycomb {
                HoneycombLayout {
                    ForEach(0..<nodes, id: \.self) { index in
                        ModelViewEmoji(name: "UISphere01", emoji: emoji[index], bundle: realityKitContentBundle)
                    }
                }
                .rotation3DLayout(Rotation3D(angle: .degrees(-90), axis: .x))

            } else {
                RadialLayout {
                    ForEach(0..<nodes, id: \.self) { index in
                        ModelViewEmoji(name: "UISphere01", emoji: emoji[index], bundle: realityKitContentBundle)
                            .rotation3DLayout(Rotation3D(angle: .degrees(-90), axis: .x))
                            .offset(z: 30 * CGFloat(index))
                    }
                }

            }
        }
        .rotation3DLayout(Rotation3D(angle: .degrees(90), axis: .x))
        .offset(y: 250)

        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                VStack(spacing: 16) {
                    // Layout toggle
                    HStack(spacing: 16) {
                        Button(action: {
                            withAnimation {
                                useHoneycomb = false
                            }
                        }, label: {
                            Text("Radial")
                                .padding()
                                .foregroundColor(useHoneycomb ? .gray : .white)
                        })

                        Button(action: {
                            withAnimation {
                                useHoneycomb = true
                            }
                        }, label: {
                            Text("Honeycomb")
                                .padding()
                                .foregroundColor(useHoneycomb ? .white : .gray)

                        })
                    }

                    // Node controls
                    HStack(spacing: 24) {
                        Button(action: {
                            withAnimation {
                                previousNodes = nodes
                                nodes -= 1
                            }
                        }, label: {
                            Image(systemName: "minus.circle.fill")
                        })
                        .disabled(nodes <= 3)

                        Text("\(nodes)")
                            .frame(width:60)
                            .contentTransition(.numericText(countsDown: nodes < previousNodes))

                        Button(action: {
                            withAnimation {
                                previousNodes = nodes
                                nodes += 1
                            }
                        }, label: {
                            Image(systemName: "plus.circle.fill")
                        })
                        .disabled(nodes >= 19)
                    }
                }
            })
        }
    }
}

#Preview {
    Lab068()
}


// Adapted from Example 051 - Spatial SwiftUI: Model3D
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
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60)
                    .spatialOverlay(alignment:  .center) {
                        Text(emoji)
                            .font(.system(size: 30))
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
        let hexSize: CGFloat = 50
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


