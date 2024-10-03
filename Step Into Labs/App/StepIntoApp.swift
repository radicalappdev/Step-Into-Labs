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

    var body: some Scene {
        WindowGroup {
            Directory()
                .environment(appModel)
        }

    }
}
