//
//  LabRouter.swift
//  Step Into Labs
//
//  Created by Joseph Simpson on 10/3/24.
//

import SwiftUI

struct LabRouter: View {
    @Binding var route: String?

    @ViewBuilder
    var body: some View {
        switch route {
        case "Lab 001": Lab001()
        case "Lab 002": Lab002()
        case "Lab 003": Lab003()
        case "Lab 004": Lab004()
        case "Lab 005": Lab005()
        case "Lab 006": Lab006()
        case "Lab 007": Lab007()
        case "Lab 008": Lab008()
//        case "Lab 009": Lab009()
        case "Lab 010": Lab010()

        case .none, .some:

            VStack {
                Text("No View could be found for " + (route ?? ""))
                    .font(.largeTitle)
                    .padding(12)
            }
            .background(.red)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }
}
