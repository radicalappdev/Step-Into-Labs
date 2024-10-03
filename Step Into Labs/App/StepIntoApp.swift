//
//  Step_Into_LabsApp.swift
//  Step Into Labs
//
//  Created by Joseph Simpson on 10/3/24.
//

import SwiftUI

@main
struct StepIntoApp: App {

    @State private var appModel = AppModel()
    @State private var modelData = ModelData()

    var body: some Scene {

        // Main window
        WindowGroup {
            Directory()
                .environment(appModel)
                .environment(modelData)
        }
        .defaultSize(CGSize(width: 700, height: 640))

        // Router scenes

    }
}
