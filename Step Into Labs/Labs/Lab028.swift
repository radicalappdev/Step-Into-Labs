//  Step Into Vision - Labs
//
//  Title: Lab028
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 1/21/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab028: View {

    @State var ornamentAnchor: UnitPoint = .init(x: 0.0, y: 0.0)
    @State private var isAutoMode = false
    @State private var autoModeTimer: Timer?
    @State private var animationPhase = 0
    
    func startAutoMode() {

        ornamentAnchor = UnitPoint(x: 0, y: 0)
        animationPhase = 0
        
        autoModeTimer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 2.0)) {
                switch animationPhase {
                case 0: // Start from Top left and move to top right
                    ornamentAnchor = UnitPoint(x: 1, y: 0)
                case 1: // Move from top right to bottom right
                    ornamentAnchor = UnitPoint(x: 1, y: 1)
                case 2: // Move from bottom right to bottom left
                    ornamentAnchor = UnitPoint(x: 0, y: 1)
                case 3: // Move from bottom left to top left
                    ornamentAnchor = UnitPoint(x: 0, y: 0)
                default:
                    break
                }
                animationPhase = (animationPhase + 1) % 4
            }
        }
    }
    
    func stopAutoMode() {
        autoModeTimer?.invalidate()
        autoModeTimer = nil
    }

    var body: some View {
        VStack {

            VStack(alignment: .leading, spacing: 20) {
                Text("Ornament Position")
                    .font(.headline)
                
                Toggle("Auto Mode", isOn: Binding(
                    get: { isAutoMode },
                    set: { newValue in
                        isAutoMode = newValue
                        if newValue {
                            startAutoMode()
                        } else {
                            stopAutoMode()
                        }
                    }
                ))
                .padding(.bottom, 8)
                
                HStack {
                    Text("X:")
                    Slider(
                        value: Binding(
                            get: { ornamentAnchor.x },
                            set: { ornamentAnchor = UnitPoint(x: $0, y: ornamentAnchor.y) }
                        ),
                        in: 0...1
                    )
                    Text(String(format: "%.2f", ornamentAnchor.x))
                }
                .fontDesign(.monospaced)
                .disabled(isAutoMode)
                
                HStack {
                    Text("Y:")
                    Slider(
                        value: Binding(
                            get: { ornamentAnchor.y },
                            set: { ornamentAnchor = UnitPoint(x: ornamentAnchor.x, y: $0) }
                        ),
                        in: 0...1
                    )
                    Text(String(format: "%.2f", ornamentAnchor.y))
                }
                .fontDesign(.monospaced)
                .disabled(isAutoMode)
            }
            .frame(width: 300)
            .padding()

        }
        .ornament(attachmentAnchor: .scene(ornamentAnchor)) {
            Text("Ornament")
                .padding(20)
                .background(.stepBlue)
                .cornerRadius(20)
        }
    }
}

#Preview {
    Lab028()
}
