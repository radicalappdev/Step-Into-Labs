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
    @State private var currentSecond: Int = 0
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            Text("Current Second: \(currentSecond)")
                .font(.title2)
                .padding()
            
            RadialLayout(angleOffset: .degrees(180)) {
                ForEach(0..<60, id: \.self) { index in
                    Circle()
                        .fill(index % 15 == 0 ? .stepGreen : .white)
                        .scaleEffect(index == currentSecond ? 2.0 : 1.0)
                        .opacity(index == currentSecond ? 1.0 : 0.25)
                        .offset(z: index == currentSecond ? 5 : 0)
                        .shadow(radius: index == currentSecond ? 5 : 0, x: 0.0, y: 0.0)
                        .animation(.easeInOut(duration: 0.5), value: currentSecond)
                        .id(index)
                }
            }
            .padding(.vertical, 20)
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private func startTimer() {
        // Update to current second immediately
        let calendar = Calendar.current
        currentSecond = calendar.component(.second, from: Date())
        
        // Start timer that updates every second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let calendar = Calendar.current
            currentSecond = calendar.component(.second, from: Date())
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
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
