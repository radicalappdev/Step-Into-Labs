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
            ClockView()
                .offset(z: 10)
                .padding(.vertical, 20)
                .manipulable()
        }
    }
}

fileprivate struct ClockView: View {
    @State private var currentSecond: Int = 0
    @State private var currentHour: Int = 0
    @State private var currentMinute: Int = 0
    @State private var timer: Timer?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .fill(.stepGreen)
                RadialLayout(angleOffset: .degrees(180)) {
                    ForEach([12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], id: \.self) { hour in
                        Text("\(hour)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.stepBackgroundPrimary)
                            .scaleEffect(min(geometry.size.width, geometry.size.height) / 400)
                    }
                }

                RadialLayout(angleOffset: .degrees(180)) {
                    ForEach(0..<60, id: \.self) { index in
                        Circle()
                            .fill(.stepBackgroundSecondary)
                            .scaleEffect(index == currentSecond ? 2.0 : 1.0)
                            .opacity(index == currentSecond ? 1.0 : 0.25)
                            .offset(z: index == currentSecond ? 5 : 0)
                            .shadow(radius: index == currentSecond ? 5 : 0, x: 0.0, y: 0.0)
                            .animation(.easeInOut(duration: 0.5), value: currentSecond)
                            .id(index)
                    }
                }
                .scaleEffect(0.74)

                ZStack {
                    // Hour hand
                    Rectangle()
                        .fill(.stepBackgroundSecondary)
                        .frame(width: 6, height: 80)
                        .offset(y: -40)
                        .offset(z: 5)
                        .rotationEffect(.degrees(Double(currentHour) * 30 + Double(currentMinute) * 0.5))
                        .shadow(radius: 1, x: 0.0, y: 0.0)
                        .scaleEffect(min(geometry.size.width, geometry.size.height) / 400)

                    // Minute hand
                    Rectangle()
                        .fill(.stepBackgroundSecondary)
                        .frame(width: 4, height: 100)
                        .offset(y: -40)
                        .offset(z: 3)
                        .rotationEffect(.degrees(Double(currentMinute) * 6))
                        .shadow(radius: 1, x: 0.0, y: 0.0)
                        .scaleEffect(min(geometry.size.width, geometry.size.height) / 400)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private func startTimer() {
        // Update to current time immediately
        updateTime()
        
        // Calculate time until next second starts
        scheduleNextUpdate()
    }
    
    private func updateTime() {
        let calendar = Calendar.current
        let now = Date().addingTimeInterval(0.1) // Add small offset to get current time
        currentSecond = calendar.component(.second, from: now)
        currentHour = calendar.component(.hour, from: now) % 12
        currentMinute = calendar.component(.minute, from: now)
    }
    
    private func scheduleNextUpdate() {
        // Get the current second interval
        let now = Date()
        guard let currentSecondInterval = Calendar.current.dateInterval(of: .second, for: now) else { return }
        
        // Calculate time until the start of the next second
        let nextSecondStart = currentSecondInterval.end
        let timeUntilNextSecond = nextSecondStart.timeIntervalSinceNow
        
        // Schedule update at the exact start of the next second
        DispatchQueue.main.asyncAfter(deadline: .now() + timeUntilNextSecond) {
            // Get time immediately when this fires
            let calendar = Calendar.current
            let currentTime = Date()
            self.currentSecond = calendar.component(.second, from: currentTime)
            self.currentHour = calendar.component(.hour, from: currentTime) % 12
            self.currentMinute = calendar.component(.minute, from: currentTime)
            self.scheduleNextUpdate() // Schedule the next update
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
