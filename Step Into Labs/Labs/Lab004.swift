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
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(1..<20) { num in
                    VStack {
                        GeometryReader { geo in
                            Text("Number \(num)")
                                .font(.largeTitle)
                                .padding()
                                .background(.red)
                                .rotation3DEffect(.degrees(-Double(geo.frame(in: .global).minX) / 8), axis: (x: 0, y: 1, z: 0))
                                .frame(width: 200, height: 200)
                                .offset(z: 200)
                        }
                        .frame(width: 200, height: 200)
                    }
                }
            }
        }
    }
}

#Preview {
    Lab004()
}
