//  Step Into Vision - Labs
//
//  Title: Lab069
//
//  Subtitle: More fun with RadialLayout
//
//  Description: Using rotation3DLayout, adjust angle, and animating some changes.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 7/17/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab069: View {

    @State private var showDebugLines = false

    // Control the total layout rotation
    @State private var layoutRotation: Double = 45
    @State private var isAnimatingRotation: Bool = false
    @State private var animationTimerRotation: Timer?

    // Adjust the angle inside the layout. This will control which element is at the front of the circle.
    @State private var angleOffset: Angle = .zero
    @State private var isAnimatingAngle: Bool = false
    @State private var animationTimerAngle: Timer?

    // Adjust an offzet on the Z axis
    @State private var offsetZ: CGFloat = 0
    @State private var isAnimatingOffsetZ: Bool = false
    @State private var animationTimerOffsetZ: Timer?
    @State private var offsetZDirection: Bool = true // true = increasing, false = decreasing

    // Adjust the bounds of the view
    @State private var bounds: CGFloat = 300
    @State private var isAnimatingBounds: Bool = false
    @State private var animationTimerBounds: Timer?
    @State private var boundsDirection: Bool = true // true = increasing, false = decreasing

    var emoji: [String] = ["🌸", "🐸", "❤️", "🔥", "💻", "🐶", "🥸", "📱", "🎉", "🚀", "🤔", "🤓", "🧲", "💰", "🤩", "🍪", "🦉", "💡", "😎"]

    var body: some View {

        VStack {

            RadialLayout(angleOffset: angleOffset) {

                ForEach(0..<11, id: \.self) { index in
                    ModelViewEmoji(name: "UISphere01", emoji: emoji[index], bundle: realityKitContentBundle)
                        .rotation3DLayout(Rotation3D(angle: .degrees(360 - layoutRotation), axis: .x))
                        .offset(z: offsetZ * CGFloat(index))
                }
            }
            .rotation3DLayout(Rotation3D(angle: .degrees(layoutRotation), axis: .x))
            .frame(width: bounds, height: bounds)
            .debugBorder3D(showDebugLines ? .white : .clear)
        }
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
                    if isAnimatingOffsetZ {
                        // Stop animation
                        animationTimerOffsetZ?.invalidate()
                        animationTimerOffsetZ = nil
                        isAnimatingOffsetZ = false
                        withAnimation(.easeInOut(duration: 0.5)) {
                            offsetZ = 0
                        }
                    } else {
                        // Start animation
                        isAnimatingOffsetZ = true
                        animationTimerOffsetZ = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                            withAnimation(.linear(duration: 0.05)) {
                                if offsetZDirection {
                                    offsetZ += 0.5
                                    if offsetZ >= 30.0 {
                                        offsetZDirection = false
                                    }
                                } else {
                                    offsetZ -= 0.5
                                    if offsetZ <= 0 {
                                        offsetZDirection = true
                                    }
                                }
                            }
                        }
                    }
                }, label: {
                    Label("Z Offset", systemImage: isAnimatingOffsetZ ? "stop" : "play")
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

#Preview {
    Lab069()
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
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
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
