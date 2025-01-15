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

            let window = Entity()
            window.setPosition([1.1, 1.5, -2], relativeTo: nil)
            content.add(window)

            // Reference view
            if let list = attachments.entity(for: "AttachmentContent") {
                list.setPosition([0.75, 1.5, -2], relativeTo: nil)
                content.add(list)
            }

            // Building the fake window
            if let windowBackground = attachments.entity(for: "WindowBackground") {
                window.addChild(windowBackground)
                windowBackground.setPosition([0 , 0, 0], relativeTo: window)
            }

            // add the title
            if let windowTitle = attachments.entity(for: "WindowTitle") {
                window.addChild(windowTitle)
                windowTitle.setPosition([-0.102 , 0.08, 0], relativeTo: window)
            }

            // add the button
            if let windowButton = attachments.entity(for: "WindowButton") {
                window.addChild(windowButton)
                windowButton.setPosition([0.102 , 0.08, 0], relativeTo: window)
            }
            
            // add the list
            if let windowList = attachments.entity(for: "WindowList") {
                window.addChild(windowList)
                windowList.setPosition([0 , -0.02, 0], relativeTo: window)
            }


        } update: { content, attachments in

        } attachments: {

            Attachment(id: "WindowBackground") {
                VStack {
                    EmptyView()
                }
                .frame(width: 400, height: 300)
                .glassBackgroundEffect()
            }

            Attachment(id: "WindowTitle") {
                    Text("Fruits")
                        .font(.title)
                        .frame(height: 60)
            }

            Attachment(id: "WindowButton") {
                Button(action: {
                    print("button pressed")
                }, label: {
                    Image(systemName: "plus")
                })
                .glassBackgroundEffect()
            }

            Attachment(id: "WindowList") {
                List {
                    Text("")
                    Text("")
                    Text("")
                }
                .frame(width: 400, height: 180)
            }


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
