//  Step Into Vision - Labs
//
//  Title: Lab028
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 1/21/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab028: View {

    @State var ornamentAnchor: UnitPoint = .init(x: 0.0, y: 0.0)

    var body: some View {
        VStack {

            VStack(alignment: .leading, spacing: 20) {
                Text("Ornament Position")
                    .font(.headline)
                
                HStack {
                    Text("X:")
                    Slider(
                        value: Binding(
                            get: { ornamentAnchor.x },
                            set: { ornamentAnchor = UnitPoint(x: $0, y: ornamentAnchor.y) }
                        ),
                        in: 0...1
                    )
                    Text(String(format: "%.2f", ornamentAnchor.x))
                }
                .fontDesign(.monospaced)
                
                HStack {
                    Text("Y:")
                    Slider(
                        value: Binding(
                            get: { ornamentAnchor.y },
                            set: { ornamentAnchor = UnitPoint(x: ornamentAnchor.x, y: $0) }
                        ),
                        in: 0...1
                    )
                    Text(String(format: "%.2f", ornamentAnchor.y))
                }
                .fontDesign(.monospaced)
            }
            .frame(width: 300)
            .padding()

        }
        .ornament(attachmentAnchor: .scene(ornamentAnchor)) {
            Text("Ornament")
                .padding(20)
                .background(.stepBlue)
                .cornerRadius(20)
        }
    }
}

#Preview {
    Lab028()
}
