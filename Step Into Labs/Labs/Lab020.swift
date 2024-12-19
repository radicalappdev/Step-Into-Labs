//  Step Into Vision - Labs
//
//  Title: Lab020
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 12/19/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab020: View {

    @State private var subscription: EventSubscription?

    var body: some View {
        RealityView { content, attachments in
            if let scene = try? await Entity(named: "Lab020Scene", in: realityKitContentBundle) {
                print("scene loaded")

                content.add(scene)

                subscription = content.subscribe(to: CollisionEvents.Began.self)  { collisionEvent in
                    print("Collision between \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")
                }
            }

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
        .modifier(DragGestureImproved())
    }
}

#Preview {
    Lab020()
}
