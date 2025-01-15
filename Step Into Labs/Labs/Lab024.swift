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

            let floor = Entity()
            floor.setPosition([0, 0, 0], relativeTo: nil)
            let floorCollision = CollisionComponent(shapes: [ShapeResource.generateBox(width: 5, height: 0.01, depth: 5)])
            floor.components.set(floorCollision)
            content.add(floor)

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

            // Add the list rows
            if let windowListRow1 = attachments.entity(for: "WindowRow1") {
                window.addChild(windowListRow1)
                windowListRow1.setPosition([0 , 0.024, 0.0001], relativeTo: window)
            }

            if let windowListRow2 = attachments.entity(for: "WindowRow2") {
                window.addChild(windowListRow2)
                windowListRow2.setPosition([0 , -0.0189, 0.0001], relativeTo: window)
            }

            if let windowListRow3 = attachments.entity(for: "WindowRow3") {
                window.addChild(windowListRow3)
                windowListRow3.setPosition([0 , -0.064, 0.0001], relativeTo: window)
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

            Attachment(id: "WindowRow1") {
                HStack{
                    Text("Apple")
                    Spacer()
                }
                .padding()
                .frame(width: 350, height: 60)
                .background(.thickMaterial)
                .clipShape(
                    .rect(
                        topLeadingRadius: 18,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 18
                    )
                )
            }

            Attachment(id: "WindowRow2") {
                HStack{
                    Text("Banana")
                    Spacer()
                }
                .padding()
                .frame(width: 350, height: 60)
                .background(.thickMaterial)

            }

            Attachment(id: "WindowRow3") {
                HStack{
                    Text("Orange")
                    Spacer()
                }
                .padding()
                .frame(width: 350, height: 60)
                .background(.thickMaterial)
                .clipShape(
                    .rect(
                        topLeadingRadius: 0,
                        bottomLeadingRadius:18,
                        bottomTrailingRadius:18,
                        topTrailingRadius: 0
                    )
                )
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
