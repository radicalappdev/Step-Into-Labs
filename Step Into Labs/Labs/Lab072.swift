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

    // Control the total layout rotation
    @State private var layoutRotation: Double = 45
    @State private var isAnimatingRotation: Bool = false
    @State private var animationTimerRotation: Timer?

    // Adjust the angle inside the layout. This will control which element is at the front of the circle.
    @State private var angleOffset: Angle = .zero
    @State private var isAnimatingAngle: Bool = false
    @State private var animationTimerAngle: Timer?

    // Adjust the bounds of the view
    @State private var bounds: CGFloat = 300
    @State private var isAnimatingBounds: Bool = false
    @State private var animationTimerBounds: Timer?
    @State private var boundsDirection: Bool = true // true = increasing, false = decreasing

    @State private var hexSize: Double = 124.0
    @State private var isAnimatingHexSize: Bool = false
    @State private var animationTimerHexSize: Timer?
    @State private var hexSizeDirection: Bool = true // true = increasing, false = decreasing

    var emoji: [String] = ["🌸", "🐸", "❤️", "🔥", "💻", "🐶", "🥸", "📱", "🎉", "🚀", "🤔", "🤓", "🧲", "💰", "🤩", "🍪", "🦉", "💡", "😎"]
    
    var body: some View {
        HoneycombLayout(angleOffset: angleOffset, hexSize: hexSize) {
            ForEach(0..<nodes, id: \.self) { index in
                ModelViewEmoji(
                    name: "UISphere01",
                    hexSize: hexSize, emoji: emoji[index],
                    bundle: realityKitContentBundle
                )
                    .rotation3DLayout(Rotation3D(angle: .degrees(360 - layoutRotation), axis: .x))
//                    .debugBorder3D(showDebugLines ? .white : .clear)

            }
        }
        .rotation3DLayout(Rotation3D(angle: .degrees(layoutRotation), axis: .x))
        .frame(width: bounds, height: bounds)
        .debugBorder3D(showDebugLines ? .white : .clear)

        .ornament(attachmentAnchor: .scene(.trailing), ornament: {

            VStack(alignment: .leading, spacing: 8) {

                Button(action: {
                    if isAnimatingRotation {
                        // Stop animation
                        animationTimerRotation?.invalidate()
                        animationTimerRotation = nil
                        isAnimatingRotation = false
                    } else {
                        // Start animation
                        isAnimatingRotation = true
                        animationTimerRotation = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                            withAnimation(.linear(duration: 0.05)) {
                                layoutRotation += 2
                            }
                        }
                    }
                }, label: {
                    Label("Rotate Layout", systemImage: isAnimatingRotation ? "stop" : "play")
                })

                Button(action: {
                    if isAnimatingAngle {
                        // Stop animation
                        animationTimerAngle?.invalidate()
                        animationTimerAngle = nil
                        isAnimatingAngle = false
                    } else {
                        // Start animation
                        isAnimatingAngle = true
                        animationTimerAngle = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                            withAnimation(.linear(duration: 0.05)) {
                                angleOffset += .degrees(2)
                            }
                        }
                    }
                }, label: {
                    Label("Angle Change", systemImage: isAnimatingAngle ? "stop" : "play")
                })

            

                Button(action: {
                    if isAnimatingBounds {
                        // Stop animation
                        animationTimerBounds?.invalidate()
                        animationTimerBounds = nil
                        isAnimatingBounds = false
                    } else {
                        // Start animation
                        isAnimatingBounds = true
                        animationTimerBounds = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                            withAnimation(.linear(duration: 0.05)) {
                                if boundsDirection {
                                    bounds += 5
                                    if bounds >= 1000 {
                                        boundsDirection = false
                                    }
                                } else {
                                    bounds -= 5
                                    if bounds <= 300 {
                                        boundsDirection = true
                                    }
                                }
                            }
                        }
                    }
                }, label: {
                    Label("Bounds", systemImage: isAnimatingBounds ? "stop" : "play")
                })

                Button(action: {
                    if isAnimatingHexSize {
                        // Stop animation
                        animationTimerHexSize?.invalidate()
                        animationTimerHexSize = nil
                        isAnimatingHexSize = false
                    } else {
                        // Start animation
                        isAnimatingHexSize = true
                        animationTimerHexSize = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                            withAnimation(.linear(duration: 0.05)) {
                                if hexSizeDirection {
                                    hexSize += 4
                                    if hexSize >= 256 {
                                        hexSizeDirection = false
                                    }
                                } else {
                                    hexSize -= 4
                                    if hexSize <= 72 {
                                        hexSizeDirection = true
                                    }
                                }
                            }
                        }
                    }
                }, label: {
                    Label("Hex Size", systemImage: isAnimatingBounds ? "stop" : "play")
                })

                Button(action: {
                    showDebugLines.toggle()
                }, label: {
                    Text("Debug")
                })

            }
            .padding()
            .controlSize(.small)
            .glassBackgroundEffect()

        })
    }
}

fileprivate struct ModelViewEmoji: View {

    @State var name: String = ""
    var hexSize: CGFloat = 40.0
    let emoji: String
    let bundle: Bundle

    // Add two computed props
    // modelSize: 80% of frame
    // textSize: 72% of frame

    var body: some View {
        SpatialContainer {

            Model3D(named: name, bundle: bundle)
            { phase in
                if let model = phase.model {
                    model
                        .resizable()
                        .frame(width: hexSize, height: hexSize)
                        .frame(depth: hexSize)
                        .scaledToFit3D()
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
        .manipulable()
        .hoverEffect()

    }
}

// Honeycomb grid layout that grows from the inside out

fileprivate struct HoneycombLayout: Layout, Animatable {
    var angleOffset: Angle = .zero
    var hexSize: CGFloat = 50



    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let updatedProposal = proposal.replacingUnspecifiedDimensions()
        let minDim = min(updatedProposal.width, updatedProposal.height)
        return CGSize(width: minDim, height: minDim)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard !subviews.isEmpty else { return }

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
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
