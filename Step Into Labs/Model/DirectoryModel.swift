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
             isFeatured: false,
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
             isFeatured: false,
             subtitle: "Exploring Physics Joints",
             description: "Loading some entities and adding physics joints between them.")

        ,Lab(title: "Lab 016",
             type: .SPACE,
             date: Date("12/04/2024"),
             isFeatured: false,
             subtitle: "Creating an entity spawner system",
             description: "Using Components and Systems to create an entity spawner system.")

        ,Lab(title: "Lab 017",
             type: .SPACE,
             date: Date("12/11/2024"),
             isFeatured: false,
             subtitle: "Exploring a Skybox Material with Shader Graph",
             description: "Having a little fun with occlusion too.")

        ,Lab(title: "Lab 018",
             type: .SPACE,
             date: Date("12/16/2024"),
             isFeatured: false,
             subtitle: "Pulling an entity out the ground",
             description: "Using occlusion material to hide an entity under the users ground or floor.")

        ,Lab(title: "Lab 019",
             type: .SPACE,
             date: Date("12/17/2024"),
             isFeatured: false,
             subtitle: "Material Sandbox",
             description: "Just a lab I'm using to view various materials in visionOS")

        ,Lab(title: "Lab 020",
             type: .SPACE,
             date: Date("12/19/2024"),
             isFeatured: false,
             subtitle: "Exploring Collision Triggers",
             description: "Starting with simple triggers to perform actions in a scene.")

        ,Lab(title: "Lab 021",
             type: .SPACE,
             date: Date("12/19/2024"),
             isFeatured: false,
             subtitle: "Collision Triggers with AnchorEntity Hands",
             description: "Do collision triggers fire from hand anchored entities without ARKit?")

        ,Lab(title: "Lab 022",
             type: .SPACE,
             date: Date("1/4/2025"),
             isFeatured: false,
             subtitle: "A simple hand menu idea",
             description: "Building a simple hand menu with hand anchors and attachments.")

        ,Lab(title: "Lab 023",
             type: .SPACE,
             date: Date("1/14/2025"),
             isFeatured: false,
             subtitle: "Anchored Bounce Box",
             description: "A mini-game that uses a hand anchor to control a box to bounce a ball toward a target.")

        ,Lab(title: "Lab 024",
             type: .SPACE,
             date: Date("1/15/2025"),
             isFeatured: false,
             subtitle: "Be careful with Windows",
             description: "They can be tricky!")

        ,Lab(title: "Lab 025",
             type: .SPACE,
             date: Date("1/16/2025"),
             isFeatured: false,
             subtitle: "Moving Windows Should Be Easy",
             description: "Is this supposed to happen?")

        ,Lab(title: "Lab 026",
             type: .SPACE,
             date: Date("1/17/2025"),
             isFeatured: false,
             subtitle: "Using Dynamic Lights and Shadows with Passthrough",
             description: "We can use ShadowReceivingOcclusionSurface to enable virtual lights and shadows to affect our real space.")

        ,Lab(title: "Lab 027",
             type: .SPACE_FULL,
            date: Date("1/18/2025"),
            isFeatured: true,
            subtitle: "When a door appears",
            description: "Enter.")

        ,Lab(title: "Lab 028",
             type: .WINDOW,
             date: Date("1/21/2025"),
             isFeatured: false,
             subtitle: "Custom Ornament Anchor Positions",
             description: "Creating a dynamic anchor that can be moved around a window.")

        ,Lab(title: "Lab 029",
             type: .SPACE,
             date: Date("1/22/2025"),
             isFeatured: false,
             subtitle: "Baggage Claim",
             description: "What if a using a color picker was like waiting at baggage claim?")

        ,Lab(title: "Lab 030",
             type: .SPACE,
             date: Date("1/23/2025"),
             isFeatured: false,
             subtitle: "The Basics of RealityKit Behaviors",
             description: "A few simple examples of RealityKit behaviors in Reality Composer Pro.")

        ,Lab(title: "Lab 031",
             type: .SPACE_FULL,
             date: Date("1/30/2025"),
             isFeatured: false,
             subtitle: "Faking some Stage Lights",
             description: "Using a cone shape, material alpha, and a spotlight to create a fake stage light effect.")

        ,Lab(title: "Lab 032",
             type: .SPACE_FULL,
             date: Date("2/7/2025"),
             isFeatured: false,
             subtitle: "The Probe",
             description: "I've been very clear about what I want. Just let me talk to the whales.")

        ,Lab(title: "Lab 033",
             type: .SPACE_FULL,
             date: Date("2/10/2025"),
             isFeatured: false,
             subtitle: "Teleportation with SpatialTapGesture",
             description: "We can't move the player/user entity in RealityKit, but we can move the world around them instead.")

        ,Lab(title: "Lab 034",
             type: .SPACE_FULL,
             date: Date("2/19/2025"),
             isFeatured: false,
             subtitle: "Teleport to waypoints",
             description: "We can teleport to fixed locations without changing the users orientation in the scene.")

        ,Lab(title: "Lab 035",
             type: .SPACE_FULL,
             date: Date("2/20/2025"),
             isFeatured: false,
             subtitle: "Teleport to viewpoints",
             description: "We can adjust the users orientation in the scene by rotating a pivot entity.")

        ,Lab(title: "Lab 036",
             type: .SPACE,
             date: Date("2/24/2025"),
             isFeatured: true,
             subtitle: "Virtual \"Reality\" Glasses",
             description: "Wait, what?")

        ,Lab(title: "Lab 037",
             type: .WINDOW,
             date: Date("3/6/2025"),
             isFeatured: true,
             subtitle: "Portal in a Window",
             description: "Learning the basics of how to use PortalComponent to render one scene inside another.")

        ,Lab(title: "Lab 038",
             type: .VOLUME,
             date: Date("3/7/2025"),
             isFeatured: true,
             subtitle: "Portal in a Volume",
             description: "Building on Lab 037, let's add a portal to a 3D shape in a volume.")

        ,Lab(title: "Lab 039",
             type: .SPACE,
             date: Date("3/9/2025"),
             isFeatured: true,
             subtitle: "Portals in Immersive Spaces",
             description: "In immersive spaces, portal contents share the same coordinate space as the main scene.")

        ,Lab(title: "Lab 040",
             type: .SPACE,
             date: Date("3/14/2025"),
             isFeatured: true,
             subtitle: "Using Portals to Swap Scenes",
             description: "")


    ]

}
