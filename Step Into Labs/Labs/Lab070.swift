//  Step Into Vision - Labs
//
//  Title: Lab070
//
//  Subtitle: Step Into Vision 2025
//
//  Description: Part of my goal to publish on Step Into Vision everyday in 2025.
//
//  Type: Window
//
//  Created by Joseph Simpson on 7/17/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab070: View {

    @State var dayOfYear: Int = 0

    func getDateForDayOfYear(_ day: Int) -> String {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        if let date = calendar.date(from: DateComponents(year: currentYear, day: day)) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd yyyy"
            return "Day \(day): " + formatter.string(from: date)
        }
        return "Day \(day)"
    }

    var body: some View {
        VStackLayout().depthAlignment(.center) {

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 20), spacing: 4) {
                ForEach(1...365, id: \.self) { day in
                    Circle()
                        .fill(day <= dayOfYear ? .stepGreen : .stepBackgroundSecondary)
                        .hoverEffect()
                        .help(getDateForDayOfYear(day))
                        .frame(width: 30, height: 30)
                }
            }
            .padding()
        }
        .ornament(attachmentAnchor: .scene(.topBack), ornament: {
            Text("Step Into Vision: 2025")
                .font(.largeTitle)
                .padding()
                .glassBackgroundEffect()
        })
        .ornament(attachmentAnchor: .scene(.bottom), ornament: {
            VStack {
                Text("Day of Year: \(dayOfYear)")
                Text("2025 is \(Int((Double(dayOfYear) / 365.0) * 100))% complete")
            }
            .padding()
            .glassBackgroundEffect()
        })
        .onAppear {
            let calendar = Calendar.current
            let today = Date()
            dayOfYear = calendar.ordinality(of: .day, in: .year, for: today) ?? 0
        }
    }
}

#Preview {
    Lab070()
}
