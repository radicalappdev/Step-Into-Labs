//  Step Into Vision - Labs
//
//  Title: Lab086
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 9/29/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab086: View {

    @State private var gameModel = GameModel()
    @State private var menu = Entity()

    @State private var willBegin: EventSubscription?
    @State private var collisionBegan: EventSubscription?

    var body: some View {
        RealityView { content in

            // Import the scene from RCP and capture the capsules
            guard let scene = try? await Entity(named: "CatchingGame", in: realityKitContentBundle) else { return }
            content.add(scene)
            guard let floor = scene.findEntity(named: "FloorBounds") else { return }
            guard let capsuleGroup = scene.findEntity(named: "Capsules") else { return }
            let mc = ManipulationComponent()
            for capsule in capsuleGroup.children {
                gameModel.capsules.append(capsule)
                capsule.components.set(mc)
            }

            // Set up the menu
            let gameMenuAttachment = ViewAttachmentComponent(rootView: GameMenu().environment(gameModel))
            menu.components.set(gameMenuAttachment)
            menu.position = .init(x: 0, y: 1.5, z: -1)
            scene.addChild(menu)

            // Set up events

            // We'll use this event to determine success
            self.willBegin = content.subscribe(to: ManipulationEvents.WillBegin.self) { event in
                gameModel.addScore()
                print("Success!")
            }

            // We'll use this event to determine failure. Anything that touches the ground is taken out of play
            self.collisionBegan = content
                .subscribe(to: CollisionEvents.Began.self, on: floor)  { collisionEvent in
                    if(gameModel.lastCollision == collisionEvent.entityB.name) {
                        return
                    }
                    print("\(collisionEvent.entityB.name) reached the ground!")
                    collisionEvent.entityB.components.remove(ManipulationComponent.self)
                    gameModel.scheduleCapsuleActivation()
                    gameModel.lastCollision = collisionEvent.entityB.name
                    collisionEvent.entityB.components.set(OpacityComponent(opacity: 0.25))
                }

        }
    }


}

@MainActor
@Observable
fileprivate class GameModel {

    enum GameState {
        case setup
        case active
        case over
    }

    var capsules: [Entity] = []
    var activeCapsules: [Entity] = []
    var gameState: GameState = .setup
    var menu = Entity()
    var score = 0
    var lastCollision: String?
    private var capsuleTimer: Task<Void, Never>?

    func startGame() {
        score = 1
        gameState = .active
        activeCapsules.append(contentsOf: capsules)
        scheduleCapsuleActivation()
    }

    func resetGame() {
        gameState = .setup
        activeCapsules.removeAll()

        let mc = ManipulationComponent()
        for capsule in capsules {
            capsule.components.set(mc)
            capsule.components[PhysicsBodyComponent.self]?.isAffectedByGravity = false
            capsule.components.set(PhysicsMotionComponent())
            capsule.position.y = 1.5
            capsule.components.remove(OpacityComponent.self)
        }
    }

    func addScore() {
        score += 1
    }

    func activateCapsule() {
        // Pick a random element from the capsules array and print the name
        guard !activeCapsules.isEmpty else { gameState = .over; return }
        let capsule = activeCapsules.randomElement()!
        print("Activating capsule: \(capsule.name)")
        // Remove the capsule from the array
        if let index = activeCapsules.firstIndex(of: capsule) {
            activeCapsules.remove(at: index)
        }
        capsule.components[PhysicsBodyComponent.self]?.isAffectedByGravity = true

        if activeCapsules.isEmpty { gameState = .over }
    }

    func scheduleCapsuleActivation() {
        capsuleTimer?.cancel()
        guard !activeCapsules.isEmpty else { gameState = .over; return }
        capsuleTimer = Task {
            let delay = Double.random(in: 3...6)
            try? await Task.sleep(for: .seconds(delay))
            await MainActor.run {
                self.activateCapsule()
            }
        }
    }

    func scheduleCapsuleDrop(after seconds: Double, action: @escaping @MainActor () -> Void) {
        capsuleTimer?.cancel()
        capsuleTimer = Task {
            try? await Task.sleep(for: .seconds(seconds))
            action()
        }
    }
}

fileprivate struct GameMenu: View {
    @Environment(GameModel.self) var gameModel

    var body: some View {
        VStack(spacing: 12) {
            Text("Capsule Catch")
                .font(.largeTitle)

            switch gameModel.gameState {
            case .setup:
                VStack {
                    Text("Use you fingers to pinch and grab as many capsules as you can!")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                    Button(action: {
                        gameModel.startGame()
                    }, label: {
                        Text("Start Game")
                    })
                }
            case .active:
                VStack {
                    Text("Temp Mode Only")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                    Button(action: {
                        gameModel.scheduleCapsuleActivation()
                    }, label: {
                        Text("Drop Test")
                    })
                }
            case .over:
                VStack {
                    // TODO: add results here
                    Text("Game Over!")
                        .font(.caption)
                    Text("Score: TBD")
                        .font(.caption)
                    Button(action: {
                        gameModel.resetGame()
                    }, label: {
                        Text("Start Over")
                    })
                }
            }


        }
        .padding()
        .frame(width: 400, height: 300)
        .glassBackgroundEffect()


    }
}
