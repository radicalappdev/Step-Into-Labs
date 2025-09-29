//
//  Step_Into_LabsApp.swift
//  Step Into Labs
//
//  Created by Joseph Simpson on 10/3/24.
//

import SwiftUI
import RealityKitContent

@main
struct StepIntoApp: App {

    @State private var appModel = AppModel()
    @State private var modelData = ModelData()
    @State private var exampleImmersionStyle: ImmersionStyle = .full

    var body: some Scene {

        // Main window
        WindowGroup {
            Directory()
                .environment(appModel)
                .environment(modelData)
        }
        .defaultSize(CGSize(width: 700, height: 640))

        // Router scenes

        // 1. Window: Use this window group to open 2D windows with Lab Content based on the Router
        WindowGroup(id: "RouterWindow", for: String.self, content: { $route in
            LabRouter(route: $route)
        })
        .defaultSize(CGSize(width: 680, height: 400))
        .defaultWindowPlacement { _, context in
            if let mainWindow = context.windows.first {
                return WindowPlacement(.trailing(mainWindow))
            }
            return WindowPlacement(.none)
        }

        // 1. Window: Use this window group to open 2D windows with Lab Content based on the Router
        WindowGroup(id: "RouterWindowAlt", for: String.self, content: { $route in
            LabRouter(route: $route)
        })
        .windowStyle(.plain)
        .defaultSize(CGSize(width: 680, height: 400))
        .defaultWindowPlacement { _, context in
            if let mainWindow = context.windows.first {
                return WindowPlacement(.trailing(mainWindow))
            }
            return WindowPlacement(.none)
        }

        // 2. Volume:  Use this window group to open 3D Volumes
        WindowGroup(id: "RouterVolume", for: String.self, content: { $route in
            let initialSize = Size3D(width: 500, height: 500, depth: 500)
            LabRouter(route: $route)
                .frame(minWidth: initialSize.width, maxWidth: initialSize.width * 2,
                       minHeight: initialSize.height, maxHeight: initialSize.height * 2)
                .frame(minDepth: initialSize.depth, maxDepth: initialSize.depth * 2)

        })
        .windowStyle(.volumetric)
        .defaultWindowPlacement { _, context in
            if let mainWindow = context.windows.first {
                return WindowPlacement(.trailing(mainWindow))
            }
            return WindowPlacement(.none)
        }

        .windowResizability(.contentMinSize)

        // 3. Space:  Use this immersive scene to open a lab in a full space
        ImmersiveSpace(id: "RouterSpace", for: String.self, content: { $route in
            LabRouter(route: $route)
                .environment(appModel)
        })
        .immersiveEnvironmentBehavior(.coexist)

        // 4. Space Full:  Use this immersive scene to open a lab in a full space
        ImmersiveSpace(id: "RouterSpaceFull", for: String.self, content: { $route in
            LabRouter(route: $route)
        })
        .immersionStyle(selection: $exampleImmersionStyle, in: .full)

    }

}
