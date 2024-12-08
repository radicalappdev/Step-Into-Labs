//
//  DirectoryModel.swift
//  Step Into Labs
//
//  Created by Joseph Simpson on 10/3/24.
//

import SwiftUI

enum LabType: String {
    case WINDOW  = "Window Content"
    case WINDOW_ALT  = "Plain Window Content"
    case VOLUME = "Volume Content"
    case SPACE = "Mixed Immersive Space"
    case SPACE_FULL = "Full Immersive Space"
}

struct Lab: Identifiable {
    let id = UUID()
    var type: LabType
    var isFeatured = false
    var date: Date
    var title: String
    var subtitle: String
    var description: String
    var success: Bool = true

    init(title: String, type: LabType, date: Date, isFeatured: Bool = false, subtitle: String, description: String, success: Bool = true) {
        self.title = title
        self.type = type
        self.isFeatured = isFeatured
        self.date = date
        self.subtitle = subtitle
        self.description = description
        self.success = success
    }
}


@Observable
class ModelData {
    var labData: [Lab] = [

        Lab(title: "Lab 001",
            type: .WINDOW,
            date: Date("10/03/2024"),
            isFeatured: false,
            subtitle: "Example of a 2D Window",
            description: "Testing out the window")

        ,Lab(title: "Lab 002",
             type: .VOLUME,
             date: Date("10/03/2024"),
             isFeatured: false,
             subtitle: "Example of a 3D Volume",
             description: "Testing out the volume")

        ,Lab(title: "Lab 003",
             type: .SPACE,
             date: Date("10/03/2024"),
             isFeatured: false,
             subtitle: "Example of an Immersive Space",
             description: "Testing out the immersive space")

        ,Lab(title: "Lab 004",
             type: .WINDOW,
             date: Date("10/06/2024"),
             isFeatured: false,
             subtitle: "Cover Flow Demo",
             description: "Taking inspiration from the [cover flow article](https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-3d-effects-like-cover-flow-using-scrollview-and-geometryreader) by Paul Hudson, I adapted this for Apple Vision Pro by adding in some offsets and opacity calculations.")

        ,Lab(title: "Lab 005",
             type: .WINDOW,
             date: Date("10/07/2024"),
             isFeatured: false,
             subtitle: "Animate Offset & rotation3DEffect",
             description: "Using rotation3DEffect along with offset to create a pseudo-3D layout. This is a revamped version of Canvatorium Visio Lab 5006, adapted for Step Into Vision.")

        ,Lab(title: "Lab 006",
             type: .WINDOW_ALT,
             date: Date("10/10/2024"),
             isFeatured: false,
             subtitle: "Stage Manager Concept",
             description: "What if Apple made Stage Manager available on visionOS as a way to group multiple windows into sets that could be moved around. This is a revamped version of Canvatorium Visio Lab 5032, adapted for Step Into Vision.")

        ,Lab(title: "Lab 007",
             type: .SPACE,
             date: Date("10/17/2024"),
             isFeatured: false,
             subtitle: "Anchor an attachment to a hand",
             description: "Create a tracked entity that will update based on the anchor, then child an attachment entity to it. No need for hand tracking or ARKit.")

        ,Lab(title: "Lab 008",
             type: .SPACE,
             date: Date("10/24/2024"),
             isFeatured: false,
             subtitle: "Anchor an Entity to the head",
             description: "Create an entity and anchor it to a point in front of the user as they move their head.")

        ,Lab(title: "Lab 009",
             type: .SPACE_FULL,
             date: Date("10/27/2024"),
             isFeatured: false,
             subtitle: "A spooky time for visionOS developers",
             description: "What really scares us?")

        ,Lab(title: "Lab 010",
             type: .SPACE,
             date: Date("10/24/2024"),
             isFeatured: false,
             subtitle: "Learning the basics of Systems",
             description: "Creating a custom component and system that will add a breathing effect to entities based on the duration entered in the component.")

        ,Lab(title: "Lab 011",
             type: .SPACE,
             date: Date("10/29/2024"),
             isFeatured: false,
             subtitle: "Playing with Occlusion Material",
             description: "Making myself a little fort and playing with occlusion material.")

        ,Lab(title: "Lab 012",
             type: .SPACE,
             date: Date("11/05/2024"),
             isFeatured: true,
             subtitle: "I'll be in my dome",
             description: "Blending several concepts together to create a simple scene.")

        ,Lab(title: "Lab 013",
             type: .SPACE,
             date: Date("11/12/2024"),
             isFeatured: false,
             subtitle: "Using targetedToEntity with a Query",
             description: "Instead of using the broad targetedToAnyEntity modifier, let's try to use targetedToEntity to query components with a custom component.")

        ,Lab(title: "Lab 014",
             type: .VOLUME,
             date: Date("11/16/2024"),
             isFeatured: false,
             subtitle: "Building an Indirect Transform System",
             description: "Use the Drag Gesture and a Toolbar to switch modes. We can use one gesture to drag, scale, and rotate our entities.")

        ,Lab(title: "Lab 015",
             type: .SPACE,
             date: Date("11/27/2024"),
             isFeatured: true,
             subtitle: "Exploring Physics Joints",
             description: "Loading some entities and adding physics joints between them.")

        ,Lab(title: "Lab 016",
             type: .SPACE,
             date: Date("12/84/2024"),
             isFeatured: true,
             subtitle: "Creating an entity spawner system",
             description: "Using Components and Systems to create an entity spawner system.")
    ]

}
