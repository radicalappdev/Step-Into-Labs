//  Step Into Vision - Labs
//
//  Title: Lab004
//
//  Subtitle:Cover Flow Demo
//
//  Description: Taking inspiration from the cover flow article by Paul Hudson, I adapted this for Apple Vision Pro by adding in some offsets and opacity calculations.
//  Based on "How to create 3D effects like Cover Flow using ScrollView and GeometryReader" by Paul Hudson
//  https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-3d-effects-like-cover-flow-using-scrollview-and-geometryreader
//  Type:
//
//  Created by Joseph Simpson on 10/6/24.

import SwiftUI
import RealityKit

struct Lab004: View {
    var body: some View {
        GeometryReader { outerGeo in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(1..<20) { num in
                        VStack {
                            GeometryReader { geo in
                                let centerX = outerGeo.size.width / 2
                                let itemCenterX = geo.frame(in: .global).midX
                                let distance = abs(itemCenterX - centerX)
                                let maxDistance = outerGeo.size.width / 2

                                let rotation = -Double(itemCenterX - centerX) / 8

                                // Keep full opacity in the central 80% of the screen
                                let fadeThreshold = maxDistance * 0.4
                                let opacity = distance < fadeThreshold ? 1.0 : max(0.1, 1.0 - (distance - fadeThreshold) / (maxDistance - fadeThreshold))

                                RoundedRectangle(cornerRadius: 24)
                                    .foregroundStyle(.black)
                                    .padding()
                                    .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
                                    .frame(width: 200, height: 200)
                                    .shadow(radius: 24)
                                    .opacity(opacity)
                                    .offset(z: 60)
                            }
                            .frame(width: 200, height: 200)
                        }
                    }
                }
                .padding(.horizontal, outerGeo.size.width / 2 - 100)
                .padding(.vertical, outerGeo.size.height / 2 - 100)
            }
        }
    }
}



#Preview {
    Lab004()
}
