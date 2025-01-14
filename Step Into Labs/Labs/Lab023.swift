//  Step Into Vision - Labs
//
//  Title: Lab023
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 1/12/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab023: View {
    var body: some View {

        @State var collisionBeganSubject: EventSubscription?
        @State var score: Int = 0


        RealityView { content, attachments in

            if let scene = try? await Entity(named: "PhysicsPlayground", in: realityKitContentBundle) {
                content.add(scene)

                if let chamber = scene.findEntity(named: "Chamber") {
                    chamber.setPosition([0, 1.4, -2], relativeTo: nil)
                }

                if let subject = scene.findEntity(named: "Ball") {
                    print("subject found")

                    collisionBeganSubject = content.subscribe(to: CollisionEvents.Began.self, on: subject)  { collisionEvent in
                        score += 1
                        print("subject collision \(collisionEvent.entityB)")
                    }
                }

            }

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
    }
}

