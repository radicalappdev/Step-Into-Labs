//  Step Into Vision - Labs
//
//  Title: Lab073
//
//  Subtitle: Ornaments can have their own ornaments
//
//  Description: I heard you like ornaments so I made you an ornament for your ornament.
//
//  Type: Window
//
//  Created by Joseph Simpson on 7/23/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab073: View {

    var body: some View {
        VStack {
            Text("🤷🏻‍♂️")
                .font(.extraLargeTitle2)
            Text("A window with an ornament with an ornament")
                .font(.headline)
        }
        .ornament(
            visibility: .automatic,
            attachmentAnchor: .scene(.topTrailingBack),
            contentAlignment: .center
        ) {
            Text("Ornament")
                .padding(12)
                .background(.black)
                .cornerRadius(12)
                .ornament(
                    visibility: .automatic,
                    attachmentAnchor: .parent(.topLeadingBack),
                    contentAlignment: .center
                ) {
                    Text("42")
                        .padding(6)
                        .background(.red)
                        .cornerRadius(20)
                }
        }
    }

}


