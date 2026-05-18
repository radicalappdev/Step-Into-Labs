//  Step Into Vision - Labs
//
//  Title: Lab111
//
//  Subtitle: Progressive Page Indicator
//
//  Description: Building a timer progress capsule in SwiftUI
//
//  Type: Window
//
//  Featured: true
//
//  Created by Joseph Simpson on 5/18/26.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab111: View {
    var body: some View {

        RoundedRectangle(cornerRadius: 12)
            .foregroundStyle(.stepRed)

        RoundedRectangle(cornerRadius: 12)
            .foregroundStyle(.stepGreen)

        RoundedRectangle(cornerRadius: 12)
            .foregroundStyle(.stepBlue)


    }
}

fileprivate struct PageControlIndicator: View {
    let count: Int
    let current: Int
    let progress: Double    // 0.0 → 1.0

    private let dotSize: CGFloat   = 8
    private let pillWidth: CGFloat = 36
    private let height: CGFloat    = 8

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<count, id: \.self) { i in
                if i == current {
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.white.opacity(0.35))
                            .frame(width: pillWidth, height: height)
                        Capsule()
                            .fill(.white)
                            .frame(width: pillWidth * progress, height: height)
                            .animation(.linear(duration: 0.05), value: progress)
                    }
                } else {
                    Circle()
                        .fill(.white.opacity(i < current ? 0.7 : 0.35))
                        .frame(width: dotSize, height: dotSize)
                }
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.75), value: current)
    }
}

#Preview {
    Lab111()
}
