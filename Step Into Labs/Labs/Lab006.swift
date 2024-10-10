//  Step Into Vision - Labs
//
//  Title: Lab006
//
//  Subtitle: Stage Manager Concept
//
//  Description: What if Apple made Stage Manager available on visionOS as a way to group multiple windows into sets that could be moved around. This is a revamped version of Canvatorium Visio Lab 5032, adapted for Step Into Vision.
//
//  Type:
//
//  Created by Joseph Simpson on 10/10/24.

import SwiftUI

struct Lab006: View {
    @State var items: [Color] = [.stepRed, .stepGreen, .stepBlue, .stepBackgroundSecondary]

    var body: some View {
        ZStack(alignment: .bottom) {
            HStack (alignment: .center, spacing: 40){
                VStack(alignment: .leading, spacing: 20)  {

                    ForEach(items[1..<4], id: \.self) { item in
                        Rectangle()
                            .foregroundColor(item)
                            .cornerRadius(12)
                            .shadow(radius: 20)
                            .frame(width: 100, height: 75)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.2)) {

                                    let clickedIndex = items.firstIndex(of: item)!
                                    items.swapAt(0, clickedIndex)
                                }
                            }
                    }


                }
                .offset(z: 24)
                .rotation3DEffect(
                    Angle(degrees: 12 ),
                    axis: (x: 0, y: 1, z: 0)
                )

                Rectangle()
                    .foregroundColor(items[0])
                    .cornerRadius(24)
                    .shadow(radius: 20)
                    .frame(width: 400 , height: 300)

            }
        }
    }
}

#Preview {
    Lab006()
}
