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

        @State var resetGame = false
        @State var score: Int = 0

        @State var collisionBeganSubject: EventSubscription?





        RealityView { content, attachments in

            if let scene = try? await Entity(named: "PhysicsPlayground", in: realityKitContentBundle) {
                content.add(scene)

                guard let chamber = scene.findEntity(named: "Chamber")  else { return }
                chamber.setPosition([0, 1.4, -2], relativeTo: nil)

                if let subject = scene.findEntity(named: "Ball") {
                    print("subject found")
                    collisionBeganSubject = content.subscribe(to: CollisionEvents.Began.self, on: subject)  { collisionEvent in
                        score += 1
//                        print("subject collision \(collisionEvent.entityB)")
                    }
                }
                
                
                // add the menu
                if let gameMenu = attachments.entity(for: "GameMenu") {
                    gameMenu.setPosition([0, -0.75, 1.1], relativeTo: chamber)
                    gameMenu.scale = [2,2,2]
                    content.add(gameMenu)
                }


            }

        } update: { content, attachments in

            if resetGame {
                print("game reset")
                if let subject = content.entities.first?.findEntity(named: "Ball") {
                    subject.setPosition([0, 0.75, 0], relativeTo: subject.parent)
                    resetGame = false
                }
            }

        } attachments: {
            Attachment(id: "GameMenu") {
                VStack {
                    Button(action: {
                        resetGame = true
                        print("game reset button pressed")
                    }, label: {
                        Text("Restart")
                    })
                }
                .padding(10)
                .background(Color.black)
                .clipShape(.capsule)
            }
        }
    }
}

