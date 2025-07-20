//  Step Into Vision - Labs
//
//  Title: Lab071
//
//  Subtitle: Presentations in Immersive Spaces?
//
//  Description: Can we use the new Presentation Component or SwiftUI Pickers in Immersive Spaces?
//
//  Type: Space
//
//  Created by Joseph Simpson on 7/20/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab071: View {

    @State private var subject = Entity()
    @State private var showingPopover: Bool = false

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "PresentationComponentLab", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.position = [-1, 1.4, -2]

            // The main entity we are looking at
            guard let subject = scene.findEntity(named: "ToyRocket") else { return }
            self.subject = subject

            // ❌ Demo 1: Using a TapGesture to show and hide a view with a Presentation Component. Adapted from Lab 064.

            // A secondary entity that we can use as the transform point for the presented popover
            guard let presentationPoint = scene.findEntity(named: "PresentationPoint") else { return }

            // We'll use a TapGesture and the new GestureComponent to toggle the popover
            let tapGesture = TapGesture()
                .onEnded({
                    Entity.animate(.bouncy, body: {
                        showingPopover.toggle()
                    })
                })
            let gestureComponent = GestureComponent(tapGesture)
            subject.components.set(gestureComponent)

            // Create the presentation component using $showingPopover to toggle presentation
            let presentation = PresentationComponent(
                isPresented: $showingPopover,
                configuration: .popover(arrowEdge: .bottom),
                content: RocketCard()
            )
            presentationPoint.components.set(presentation)

            // ❌ Demo 2: Adding an attachment entity. The SwiftUI view in the attachment uses picker controls, which rely on Presentations.
            let attachmentEntity = Entity()
            let attachment = ViewAttachmentComponent(rootView: FormView())
            attachmentEntity.components.set(attachment)
            subject.addChild(attachmentEntity, preservingWorldTransform: false)
            attachmentEntity.setPosition([0, 0.25, 0], relativeTo: subject)

        }

    }
}

fileprivate struct RocketCard: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("Rocket")
                .font(.largeTitle)

            Text("🚀🚀🚀🚀🚀")
                .font(.largeTitle)
        }
        .foregroundStyle(.black)
        .textCase(.uppercase)
        .padding()
    }
}

fileprivate struct FormView: View {

    var title: String = "Immersive Space Presentations!"

    @State private var showingSheet = false
    @State private var showingPopover = false
    @State private var someDate = Date()

    var body: some View {
        Form() {

            Text(title)
                .font(.largeTitle)

            Button("Show Sheet", action: {
                showingSheet.toggle()
            })

            Button("Show Popover", action: {
                showingPopover.toggle()
            })

            DatePicker("Date Picker",
                       selection: $someDate,
                       displayedComponents: .date
            )

        }
        .sheet(isPresented: $showingSheet) {
            VStack {
                Text("Sheets show up somewhere in the volume, relative to the user")
                    .padding()
                Button("Close Sheet", action: {
                    showingSheet = false
                })
            }
        }
        .popover(isPresented: $showingPopover, attachmentAnchor: .point(.trailing), arrowEdge: .leading, content: {
            VStack {
                Text("Popovers")
                    .padding()
                Button("Close Popover", action: {
                    showingPopover = false
                })
            }
        })
        .frame(width: 400, height: 300)
        .glassBackgroundEffect()
    }
}


#Preview {
    Lab071()
}
