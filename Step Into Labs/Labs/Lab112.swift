//  Step Into Vision - Labs
//
//  Title: Lab112
//
//  Subtitle: Arc Slider
//
//  Description:
//
//  Type: Volume
//
//  Featured:
//
//  Created by Joseph Simpson on 5/20/26.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab112: View {
    @State private var rotationDegrees = 0.0

    private var arcValue: Binding<Double> {
        Binding {
            rotationDegrees / 90
        } set: { newValue in
            rotationDegrees = newValue * 90
        }
    }

    var body: some View {
        VStack {

            RoundedRectangle(cornerRadius: 12)
                .fill(.stepRed)
                .frame(width: 200, height: 160)
            // use the new rotation3DLayout to rorate this view. 
                .rotation3DLayout(.degrees(rotationDegrees), axis: .x)


        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                // Place the slider here
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Rotation")
                            .fontWeight(.semibold)

                        Spacer()

                        Text(rotationDegrees, format: .number.precision(.fractionLength(0)))
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }

                    Slider(value: $rotationDegrees, in: 0...90)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .frame(width: 320)
            })
        }
        .ornament(attachmentAnchor: .scene(.trailing), contentAlignment: .trailing) {
            ArcSlider(value: arcValue)
                .padding(24)
        }
    }
}

fileprivate struct ArcSlider: View {
    @Binding var value: Double

    private let size: CGFloat = 220
    private let radius: CGFloat = 140
    private let lineWidth: CGFloat = 8
    private let handleSize: CGFloat = 44

    var body: some View {
        VStack(spacing: 0) {
            ArcSliderTrack(
                radius: radius,
                value: value,
                lineWidth: lineWidth
            )
            .frame(width: size, height: size)
            .overlay(alignment: .topLeading) {
                Circle()
                    .fill(.stepBlue)
                    .frame(width: handleSize, height: handleSize)
                    .offset(
                        x: handlePosition.x - handleSize / 2,
                        y: handlePosition.y - handleSize / 2
                    )
                    .rotation3DEffect(.degrees(-90), axis: .y)
            }
        }
        .frame(width: size, height: size)
        .rotation3DLayout(.degrees(90), axis: .y)
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { gesture in
                    value = value(for: gesture.location)
                }
        )
    }

    private var center: CGPoint {
        CGPoint(x: size - 28, y: size - 28)
    }

    private var handlePosition: CGPoint {
        let angle = Angle.degrees(180 + value * 90).radians
        return CGPoint(
            x: center.x + cos(angle) * radius,
            y: center.y + sin(angle) * radius
        )
    }

    private func value(for location: CGPoint) -> Double {
        let radians = atan2(location.y - center.y, location.x - center.x)
        var degrees = Angle.radians(radians).degrees

        if degrees < 0 {
            degrees += 360
        }

        return min(max((degrees - 180) / 90, 0), 1)
    }
}

fileprivate struct ArcSliderTrack: View {
    let radius: CGFloat
    let value: Double
    let lineWidth: CGFloat

    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width - 28, y: size.height - 28)

            var basePath = Path()
            basePath.addArc(
                center: center,
                radius: radius,
                startAngle: .degrees(180),
                endAngle: .degrees(270),
                clockwise: false
            )

            var activePath = Path()
            activePath.addArc(
                center: center,
                radius: radius,
                startAngle: .degrees(180),
                endAngle: .degrees(180 + value * 90),
                clockwise: false
            )

            let strokeStyle = StrokeStyle(lineWidth: lineWidth, lineCap: .round)
            context.stroke(basePath, with: .color(.secondary.opacity(0.35)), style: strokeStyle)
            context.stroke(activePath, with: .color(.primary), style: strokeStyle)
        }
    }
}

#Preview {
    Lab112()
}
