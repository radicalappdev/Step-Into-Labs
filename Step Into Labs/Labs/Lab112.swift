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
    }
}

#Preview {
    Lab112()
}
