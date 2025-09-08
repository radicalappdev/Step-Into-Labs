//  Step Into Vision - Labs
//
//  Title: Lab080
//
//  Subtitle: First Look at Unified Coordinate Conversion
//
//  Description: visionOS 26 brings a new unified coordinate system that we can use in SwiftUI and RealityKit.
//
//  Type: Window
//
//  Created by Joseph Simpson on 8/30/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab080: View {

    @State private var posX: Float = 0
    @State private var posY: Float = 0
    @State private var posZ: Float = 0

    var body: some View {
        GeometryReader3D { geometry in

            VStack {
                Text("Unified Coordinate Conversion")
                    .font(.largeTitle)
                    .padding(24)

                VStack {
                    Text("X: \(posX)")
                    Text("Y: \(posY)")
                    Text("Z: \(posZ)")
                }
                .font(.title)
                .padding(24)

            }
            .onGeometryChange3D(for: Point3D.self) { proxy in try! proxy
                    .coordinateSpace3D()
                    .convert(value: Point3D.zero, to: .worldReference)
            } action: { old, new in
                posX = Float(new.x)
                posY = Float(new.y)
                posZ = Float(new.z)
            }
        }
    }
}

#Preview {
    Lab080()
}
