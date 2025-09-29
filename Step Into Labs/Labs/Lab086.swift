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



    @State var menu = Entity()

    var body: some View {
        RealityView { content in

            // Import the scene from RCP and capture the capsules
            guard let scene = try? await Entity(named: "CatchingGame", in: realityKitContentBundle) else { return }
            content.add(scene)

            guard let capsuleGroup = scene.findEntity(named: "Capsules") else { return }
            for capsule in capsuleGroup.children {
                gameModel.capsules.append(capsule)
            }

            // Set up the menu
            let gameMenuAttachment = ViewAttachmentComponent(rootView: GameMenu().environment(gameModel))
            menu.components.set(gameMenuAttachment)
            menu.position = .init(x: 0, y: 1.5, z: -1)
            scene.addChild(menu)

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

    func activateCapsule() {
        // Pick a random element from the capsules array and print the name
        guard !activeCapsules.isEmpty else { gameState = .over; return }
        let capsule = activeCapsules.randomElement()!
        print("Activating capsule: \(capsule.name)")
        // Remove the capsule from the array
        if let index = activeCapsules.firstIndex(of: capsule) {
            activeCapsules.remove(at: index)
        }
    }

    func startGame() {
        gameState = .active
        activeCapsules.append(contentsOf: capsules)
    }

    func resetGame() {
        gameState = .setup
        activeCapsules.removeAll()
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
                        gameModel.activateCapsule()
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
