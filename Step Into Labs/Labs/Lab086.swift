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

    @State var capsules: [Entity] = []
    @State var gameActive: Bool = false
    @State var menu = Entity()

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "CatchingGame", in: realityKitContentBundle) else { return }
            content.add(scene)

            guard let capsuleGroup = scene.findEntity(named: "Capsules") else { return }
            for capsule in capsuleGroup.children {
                capsules.append(capsule)
            }


            // Set up the menu
            let gameMenuAttachment = ViewAttachmentComponent(rootView: GameMenu(gameActive: $gameActive))
            menu.components.set(gameMenuAttachment)
            menu.position = .init(x: 0, y: 1.2, z: -1)
            scene.addChild(menu)


        }
    }
}

fileprivate struct GameMenu: View {

    @Binding var gameActive: Bool

    var body: some View {
        VStack {
            Text("Capsule Catch")
                .font(.largeTitle)
            Text("Use you fingers to pinch and grab the capsules when they drop. Catch as many as you can!")
                .font(.caption)

            Button(action: {
                gameActive = true
            }, label: {
                Text("START")
            })
        }
        .frame(width: 400, height: 300)
        .glassBackgroundEffect(
            .feathered(
                padding: 24,
                softEdgeRadius: 4
            ),
            displayMode: .always
        )


    }
}
