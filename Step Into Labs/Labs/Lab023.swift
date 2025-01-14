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
    @State var resetGame = false
    @State var score: Int = 0

    @State var collisionBeganSubject: EventSubscription?

    @State var ball = Entity()
    @State var box = Entity()


    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "PhysicsPlayground", in: realityKitContentBundle) {
                content.add(scene)

                guard let chamber = scene.findEntity(named: "Chamber")  else { return }
                chamber.setPosition([0, 1.4, -2], relativeTo: nil)
                chamber.setScale([0.5, 0.5, 0.5], relativeTo: nil)

                if let ball = scene.findEntity(named: "Ball"), let box = scene.findEntity(named: "Box") {
                    print("subject found")
                    self.ball = ball
                    self.box = box
                    collisionBeganSubject = content.subscribe(to: CollisionEvents.Began.self, on: ball)  { collisionEvent in
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



        } attachments: {
            Attachment(id: "GameMenu") {
                VStack {
                    Button(action: {
                        print("game reset button pressed")
                        ball.setPosition([0, 0, 0], relativeTo: ball.parent)
                        // position the ball at a random position relative to the parent
                        // clamp values between 0.9 and -0.9 on all axis

                    }, label: {
                        Text("Start Game")
                    })
                }
                .padding(10)
                .background(Color.black)
                .clipShape(.capsule)
            }
        }
    }
}

