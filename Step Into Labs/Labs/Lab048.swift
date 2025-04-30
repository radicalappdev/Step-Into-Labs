//  Step Into Vision - Labs
//
//  Title: Lab048
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 4/30/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab048: View {

    @State var window = Entity()
    @State var windowYPosition: Float = 0

    var body: some View {
        RealityView { content, attachments in

            content.add(window)

            if let panel = attachments.entity(for: "NotAWindow") {
                window.addChild(panel)
                panel.setScale([0.5, 0.5, 0.5], relativeTo: window)
                panel.setPosition([0, 0, 0], relativeTo: window)
            }

        } update: { content, attachments in

            if let panel = attachments.entity(for: "NotAWindow") {
                panel.setPosition([0, windowYPosition, 0], relativeTo: window)
            }

        } attachments: {
            Attachment(id: "NotAWindow") {
                VStack {
                    HStack {
                        Text("Fruits")
                            .font(.title)
                            .frame(height: 60)
                        Spacer()
                        Button(action: {
                            print("button pressed")
                            windowYPosition = 0.1
                        }, label: {
                            Image(systemName: "plus")
                        })
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    List {
                        Text("Apple")
                        Text("Banana")
                        Text("Orange")
                    }
                }
                .frame(width: 400, height: 300)
                .glassBackgroundEffect()
            }
        }
    }
}

#Preview {
    Lab048()
}
