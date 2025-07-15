//  Step Into Vision - Labs
//
//  Title: Lab067
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 7/14/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab067: View {

    @State var nodes: Int = 5
    @State var previousNodes: Int = 5

    var emoji: [String] = ["💎", "🐸", "🤔", "🔥", "💻", "🐶", "🥸", "📱", "🎉", "🚀", "❤️", "🤓", "🧲", "💰", "🤩", "🍪", "🦉", "💡", "😎", "🌸"]

    var body: some View {
        VStack {
            RadialLayout {
                ForEach(0..<nodes, id: \.self) { index in
                    Text(emoji[index])
                        .font(.system(size: 40))
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                HStack(spacing: 24) {
                    Button(action: {
                        withAnimation {
                            previousNodes = nodes
                            nodes -= 1
                        }
                    }, label: {
                        Image(systemName: "minus.circle.fill")
                    })
                    .disabled(nodes <= 5)

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
                    .disabled(nodes >= 20)
                }
            })
        }
    }
}

#Preview {
    Lab067()
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
