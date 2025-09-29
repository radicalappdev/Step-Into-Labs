//  Step Into Vision - Labs
//
//  Title: Lab086
//
//  Subtitle: Capsule Catch
//
//  Description: A mini-game drop and catch game.
//
//  Type: Space
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

            // Reducing gravity just a bit
            var ps = PhysicsSimulationComponent()
            ps.gravity = [0, -9.81 * 0.8, 0]
            scene.components.set(ps)
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
            menu.position = .init(x: 0, y: 1.2, z: -1)
            scene.addChild(menu)

            // We'll use this event to determine success
            self.willBegin = content.subscribe(to: ManipulationEvents.WillBegin.self) { event in
                if(gameModel.lastInteraction == event.entity.name) {
                    return
                }
                if(gameModel.caughtCapsules.contains(where: { $0.name == event.entity.name })) {
                    return
                }
                gameModel.addScore()
                gameModel.caughtCapsules.append(event.entity)
                gameModel.scheduleCapsuleActivation()
                gameModel.lastInteraction = event.entity.name
                print("Success!")
            }

            // We'll use this event to determine failure. Anything that touches the ground is taken out of play
            self.collisionBegan = content
                .subscribe(to: CollisionEvents.Began.self, on: floor)  { collisionEvent in
                    if(gameModel.lastInteraction == collisionEvent.entityB.name) {
                        return
                    }
                    if(gameModel.caughtCapsules.contains(where: { $0.name == collisionEvent.entityB.name })) {
                        return
                    }
                    print("\(collisionEvent.entityB.name) reached the ground without a score!")
                    collisionEvent.entityB.components.remove(ManipulationComponent.self)
                    gameModel.scheduleCapsuleActivation()
                    gameModel.lastInteraction = collisionEvent.entityB.name
                    collisionEvent.entityB.components.set(OpacityComponent(opacity: 0.1))
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
    var caughtCapsules: [Entity] = []
    var gameState: GameState = .setup
    var menu = Entity()
    var score = 0
    var lastInteraction: String?
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

        // Reset each capsule to their default state
        let mc = ManipulationComponent()
        for capsule in capsules {
            capsule.components.set(mc)
            capsule.components[PhysicsBodyComponent.self]?.isAffectedByGravity = false
            capsule.components.set(PhysicsMotionComponent())
            capsule.transform.rotation = .init()
            capsule.position.y = 2
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

        // Remove the capsule from the array
        if let index = activeCapsules.firstIndex(of: capsule) {
            activeCapsules.remove(at: index)
        }

        Task {
            // TODO: consider playing a spatial sound effect to draw attention
            let action = EmphasizeAction(motionType: .pulse,
                                         style: .basic,
                                                  isAdditive: false)
            let animation = try AnimationResource.makeActionAnimation(for: action,
                                                                      duration: 0.25,
                                                                      bindTarget: .transform)
            capsule.playAnimation(animation)
            // todo: wait for 0.25
            try? await Task.sleep(nanoseconds: 250_000_000)
            capsule.components[PhysicsBodyComponent.self]?.isAffectedByGravity = true
        }
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
                    Text("Game Over!")
                        .font(.caption)
                    Text("Score: \(gameModel.score) out of 7")
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
        .opacity(gameModel.gameState == .active ? 0.0 : 1.0)
    }
}
