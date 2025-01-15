//  Step Into Vision - Labs
//
//  Title: Lab024
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 1/15/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab024: View {
    var body: some View {
        RealityView { content, attachments in

            if let list = attachments.entity(for: "AttachmentContent") {

                list.setPosition([0.75, 1.5, -2], relativeTo: nil)
                content.add(list)

            }

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                NavigationStack {
                    List {
                        Text("Apple")
                        Text("Banana")
                        Text("Orange")
                    }
                    .navigationTitle("Fruits")
                    .toolbar {
                        Button(action: {
                            print("button pressed")
                        }, label: {
                            Image(systemName: "plus")
                        })
                    }
                }
                .frame(width: 400, height: 300)
                .glassBackgroundEffect()
            }
        }
    }
}

#Preview {
    Lab024()
}
