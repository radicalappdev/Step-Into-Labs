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
             isFeatured: true,
             subtitle: "Anchor an attachment to a hand",
             description: "TBD")





        ,Lab(title: "Lab 010",
             type: .SPACE,
             date: Date("10/24/2024"),
             isFeatured: true,
             subtitle: "Learning the basics of Systems",
             description: "TBD")
    ]

}
