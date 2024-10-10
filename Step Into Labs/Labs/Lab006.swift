//
//  Lab006.swift
//  Step Into Labs
//
//  Created by Joseph Simpson on 10/10/24.
//

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
                            .cornerRadius(24)
                            .shadow(radius: 20)
                            .frame(width: 260, height: 180)
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
                    .frame(width: 900, height: 600)

            }
            //            .offset(z: 300)
        }
    }
}

#Preview {
    Lab006()
}
