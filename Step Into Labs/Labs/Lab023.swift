//  Step Into Vision - Labs
//
//  Title: Lab023
//
//  Subtitle: Anchored Bounce Box
//
//  Description: A mini-game that uses a hand anchor to control a box to bounce a ball toward a target.
//
//  Type: Space
//
//  Created by Joseph Simpson on 1/12/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab023: View {

    // ARKit
    @State var session = SpatialTrackingSession()
    @State var handControl: Entity?

    // Game State
    @State var gameActive = false
    @State var gameWon = false
    @State var score: Int = 0

    // These will be replaced with entities from the RCP scene
    @State var chamber = Entity()
    @State var ball = Entity()
    @State var box = Entity()

    // Stash the collision event
    @State var collisionBeganSubject: EventSubscription?

    var body: some View {
        RealityView { content, attachments in

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
                    if(gameWon && score > 0) {
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
            await runTrackingSession()
        }
        .task {
            
            while true {
                // If the game is active, use the anchor orientation to tilt the chamber
                if gameActive {
                    if let anchor = handControl {
                        let anchorTransform = Transform(matrix: anchor.transformMatrix(relativeTo: nil))

                        // Create a new transform that uses position and scale from the chamber, and rotation from the anchor
                        var transform = Transform()
                        transform.translation = chamber.position
                        transform.scale = chamber.scale
                        transform.rotation = anchorTransform.rotation
                        // Use move(to:...) to smooth out the orientation changes
                        chamber.move(to: transform, relativeTo: nil, duration: 0.03)

                    }
                }
                try? await Task.sleep(for: .seconds(1/30))
            }

        }
    }

    func runTrackingSession() async {
        let configuration = SpatialTrackingSession.Configuration(tracking: [.hand])
        await session.run(configuration)
    }

    func startGame() {

        // Position the ball and box for another round
        ball.setPosition([0, 0.5, 0], relativeTo: ball.parent)
        box.setPosition([Float.random(in: -0.9...0.9), Float.random(in: -0.9...0.9), Float.random(in: -0.9...0.9)], relativeTo: box.parent)
        // Reenable gravity
        if var ballPhysics = ball.components[PhysicsBodyComponent.self] {
            ballPhysics.isAffectedByGravity = true
            ball.components.set(ballPhysics)
        }

        // Start the game
        ball.isEnabled = true
        box.isEnabled = true
        gameActive = true
        gameWon = false
        score = 0
    }

    func gameOver() {
        gameActive = false

        // clear all velocity on the ball
        if var ballMotion = ball.components[PhysicsMotionComponent.self] {
            ballMotion.angularVelocity = [0,0,0]
            ballMotion.linearVelocity = [0,0,0]
            ball.components.set(ballMotion)
        }

        // disable gravity
        if var ballPhyics = ball.components[PhysicsBodyComponent.self] {
            ballPhyics.isAffectedByGravity = false
            ball.components.set(ballPhyics)
        }

        // Reset the box and disable it
        box.setPosition([0.25, 0.5, 0], relativeTo: box.parent)
        box.isEnabled = false
        ball.isEnabled = false

        // Reset the chamber orientation
        let resetTransform = Transform()
        chamber.setOrientation(resetTransform.rotation, relativeTo: nil)

        // Fire a particle burst
        if(gameWon) {
            if var fireworks = chamber.components[ParticleEmitterComponent.self] {
                fireworks.burst()
                chamber.components.set(fireworks)
            }

        }
    }
}

