//  Step Into Vision - Labs
//
//  Title: Lab004
//
//  Subtitle:
//
//  Description:
//
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
                                let rotation = -Double(itemCenterX - centerX) / 8

                                RoundedRectangle(cornerRadius: 24)
                                    .foregroundStyle(.black)
                                    .padding()
                                    .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
                                    .frame(width: 200, height: 200)
                                    .offset(z: 40)
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
