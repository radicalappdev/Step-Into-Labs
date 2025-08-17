//  Step Into Vision - Labs
//
//  Title: Lab076
//
//  Subtitle: ArcLayout
//
//  Description: Adapting the RadialLayout from Apple into an ArcLayout.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 8/11/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab076: View {

    @State var nodes: Int = 12
    @State var previousNodes: Int = 3
    @State var arcDegrees: Double = 180
    @State var angleOffsetDegrees: Double = 0
    @State var shouldAutoCenter = true

    var emoji: [String] = ["🌸", "🐸", "❤️", "🔥", "💻", "🐶", "🥸", "📱", "🎉", "🚀", "🤔", "🤓", "🧲", "💰", "🤩", "🍪", "🦉", "💡", "😎"]

    var body: some View {

        VStack {
            ArcLayout(angleOffset: .degrees(angleOffsetDegrees), degrees: arcDegrees, shouldAutoCenter: shouldAutoCenter) {
                ForEach(0..<nodes, id: \.self) { index in
                    ModelViewEmoji(name: "UISphere01", emoji: emoji[index], bundle: realityKitContentBundle)
                }
            }
            .debugBorder3D(.white)
        }

        .ornament(attachmentAnchor: .scene(.trailing), contentAlignment: .leading, ornament: {
            VStack(spacing: 6) {

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
                        .frame(width:80)
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

                // Arc controls
                HStack(spacing: 24) {

                    Button(action: {
                        withAnimation {
                            arcDegrees = max(45, arcDegrees - 45)
                        }
                    }, label: {
                        Image(systemName: "minus.circle.fill")
                    })
                    .disabled(arcDegrees <= 45)

                    Text("Arc: \(Int(arcDegrees))°")
                        .frame(width: 80)

                                         Button(action: {
                         withAnimation {
                             arcDegrees = min(360, arcDegrees + 45)
                         }
                     }, label: {
                         Image(systemName: "plus.circle.fill")
                     })
                     .disabled(arcDegrees >= 225)
                 }
                 
                 // Angle offset controls
                 HStack(spacing: 24) {
                     Button(action: {
                         withAnimation {
                             angleOffsetDegrees -= 45
                         }
                     }, label: {
                         Image(systemName: "minus.circle.fill")
                     })
                     
                     Text("Offset: \(Int(angleOffsetDegrees))°")
                         .frame(width: 80)
                     
                     Button(action: {
                         withAnimation {
                             angleOffsetDegrees += 45
                         }
                     }, label: {
                         Image(systemName: "plus.circle.fill")
                     })
                 }

                Button(action: {
                    withAnimation {
                        shouldAutoCenter.toggle()
                    }
                }, label: {
                    Label("Auto-center", systemImage: shouldAutoCenter ? "circle.circle.fill" : "circle")
                })
            }
            .padding()
            .glassBackgroundEffect()
        })
    }
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
                    .frame(width: 90)
                    .spatialOverlay(alignment:  .center) {
                        Text(emoji)
                            .font(.system(size: 42))
                    }
            } else if phase.error != nil {
                Text(emoji) // just load the emoji without the model
            } else {
                ProgressView()
            }
        }
    }
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

#Preview {
    Lab076()
}
