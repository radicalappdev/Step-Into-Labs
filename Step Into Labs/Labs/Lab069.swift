//  Step Into Vision - Labs
//
//  Title: Lab069
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 7/17/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab069: View {

    @State var nodes: Int = 12
    @State var previousNodes: Int = 3
    @State var useHoneycomb: Bool = false

    @State private var angleOffset: Angle = .zero
    @State private var offsetZ: CGFloat = 0

    @State private var layoutRotation: Double = 45
    @State private var bounds: CGFloat = 300


    var emoji: [String] = ["🌸", "🐸", "❤️", "🔥", "💻", "🐶", "🥸", "📱", "🎉", "🚀", "🤔", "🤓", "🧲", "💰", "🤩", "🍪", "🦉", "💡", "😎"]

    var body: some View {

        VStack {

            RadialLayout(angleOffset: angleOffset) {

                ForEach(0..<nodes, id: \.self) { index in
                    ModelViewEmoji(name: "UISphere01", emoji: emoji[index], bundle: realityKitContentBundle)
                        .rotation3DLayout(Rotation3D(angle: .degrees(360 - layoutRotation), axis: .x))
                        .offset(z: offsetZ * CGFloat(index))
                }
            }
            .rotation3DLayout(Rotation3D(angle: .degrees(layoutRotation), axis: .x))
            .frame(width: bounds, height: bounds)
        }
        .ornament(attachmentAnchor: .scene(.trailing), ornament: {

            VStack(alignment: .center, spacing: 8) {

                Button(action: {
                    withAnimation {
                        layoutRotation = 0
                    }
                }, label: {
                    Text("Rotate 0")
                })
                Button(action: {
                    withAnimation {
                        layoutRotation = 45
                    }
                }, label: {
                    Text("Rotate 45")
                })
                Button(action: {
                    withAnimation {
                        layoutRotation = 90
                    }
                }, label: {
                    Text("Rotate 90")
                })

            }
            .padding()
            .controlSize(.small)
            .glassBackgroundEffect()

        })


        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
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

            })
        }

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
