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

    @State var session: SpatialTrackingSession?
    @State var handControl: Entity?


    @State var gameActive = false
    @State var gameWon = false
    @State var score: Int = 0

    @State var collisionBeganSubject: EventSubscription?

    @State var chamber = Entity()
    @State var ball = Entity()
    @State var box = Entity()


    var body: some View {
        RealityView { content, attachments in

            let configuration = SpatialTrackingSession.Configuration(
                tracking: [.hand])
            let session = SpatialTrackingSession()
            await session.run(configuration)

            if let scene = try? await Entity(named: "PhysicsPlayground", in: realityKitContentBundle) {
                content.add(scene)

                guard let chamber = scene.findEntity(named: "Chamber")  else { return }
                chamber.setPosition([0, 1.4, -2], relativeTo: nil)
                chamber.setScale([0.5, 0.5, 0.5], relativeTo: nil)
                self.chamber = chamber

                if let ball = scene.findEntity(named: "Ball"), let box = scene.findEntity(named: "Box") {
                    self.ball = ball
                    self.box = box
                    collisionBeganSubject = content.subscribe(to: CollisionEvents.Began.self, on: ball)  { collisionEvent in

                        if(collisionEvent.entityB == box) {
                            print("subject collision \(collisionEvent.entityB)")
                            gameWon = true
                            gameOver()
                        }

                        if(gameActive) {
                            score += 1
                        }
                    }
                }

                if let handControl = scene.findEntity(named: "HandControl") {
                    self.handControl = handControl
                }


                if let gameMenu = attachments.entity(for: "GameMenu") {
                    gameMenu.setPosition([0, -1.2, 1.1], relativeTo: chamber)
                    gameMenu.scale = [2,2,2]
                    content.add(gameMenu)
                }
            }

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "GameMenu") {
                VStack {
                    HStack {
                        Button(action: {
                            gameWon = false
                            gameOver()
                        }, label: {
                            Text("Stop")
                        })

                        Button(action: {
                            startGame()
                        }, label: {
                            Text("Restart")
                        })
                    }
                    if(gameActive == false && score > 0) {
                        Text("You Won in \(score) bounces!")
                    } else {
                        Text("Collide with the box!")
                    }
                }
                .padding(10)
                .frame(width: 400, height: 100)
                .background(Color.black)
                .clipShape(.capsule)
            }
        }
        .persistentSystemOverlays(.hidden)
        .upperLimbVisibility(.hidden)
        .task {
            while true {
                // Periodically check the anchor transform and stash it in SwiftUi state.

                if gameActive {
                    if let anchor = handControl {
                        let transform = Transform(matrix: anchor.transformMatrix(relativeTo: nil))
                        chamber.setOrientation(transform.rotation, relativeTo: nil)

                    }

                }
                try? await Task.sleep(for: .seconds(1/30))
            }

        }
    }

    func startGame() {
        gameActive = true
        gameWon = false
        score = 0
        ball.setPosition([0, 0.5, 0], relativeTo: ball.parent)
        if var ballMotion = ball.components[PhysicsMotionComponent.self] {
            // clear all velocity
            ballMotion.angularVelocity = [0,0,0]
            ballMotion.linearVelocity = [0,0,0]
            ball.components.set(ballMotion)
        }
        if var ballPhyics = ball.components[PhysicsBodyComponent.self] {
            ballPhyics.isAffectedByGravity = true
            ball.components.set(ballPhyics)
        }
        box.setPosition([Float.random(in: -0.9...0.9), Float.random(in: -0.9...0.9), Float.random(in: -0.9...0.9)], relativeTo: box.parent)
        ball.isEnabled = true
        box.isEnabled = true
    }

    func gameOver() {
        gameActive = false

        ball.setPosition([0.25, 0.5, 0], relativeTo: ball.parent)
        if var ballPhyics = ball.components[PhysicsBodyComponent.self] {
            ballPhyics.isAffectedByGravity = false
            ball.components.set(ballPhyics)
        }
        box.setPosition([0.25, 0.5, 0], relativeTo: box.parent)
        ball.isEnabled = false
        box.isEnabled = false
        let resetTransform = Transform()
        chamber.setOrientation(resetTransform.rotation, relativeTo: nil)
        if(gameWon) {
            if var fireworks = chamber.components[ParticleEmitterComponent.self] {
                fireworks.burst()
                chamber.components.set(fireworks)
            }

        }
    }
}

