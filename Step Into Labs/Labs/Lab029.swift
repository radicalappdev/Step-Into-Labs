//  Step Into Vision - Labs
//
//  Title: Lab029
//
//  Subtitle: Baggage Claim
//
//  Description: What if a using a color picker was like waiting at baggage claim?
//
//  Type: Space
//
//  Created by Joseph Simpson on 1/22/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab029: View {
    @State private var colors: [Color] = [
        .red,
        .pink,
        .orange,
        .yellow,
        .green,
        .mint,
        .teal,
        .cyan,
        .blue,
        .indigo,
        .purple,
        .brown,
        .white,
        Color(uiColor: .systemGray),
        Color(uiColor: .systemGray2),
        Color(uiColor: .systemGray3),
        Color(uiColor: .systemGray4),
        Color(uiColor: .systemGray5),
        Color(uiColor: .systemGray6),
        .black
    ]

    var body: some View {
        List {
            ForEach(Array(colors.enumerated()), id: \.offset) { index, color in
                HStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color)
                        .frame(width: 50, height: 30)
                    Text("Color \(index + 1)")
                }
            }
        }
    }
}

#Preview {
    Lab029()
}
