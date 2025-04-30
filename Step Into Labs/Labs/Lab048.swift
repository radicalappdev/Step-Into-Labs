//  Step Into Vision - Labs
//
//  Title: Lab048
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 4/30/25.

import RealityKit
import RealityKitContent
import SwiftUI

struct Lab048: View {

    @State var windowIsOpen = false

  // The root for our scene *outside* of the portal
  private let rootEntity = Entity()

  // An entity that will render the portal
  private let portalPlane = ModelEntity(
    mesh: .generatePlane(width: 1.0, height: 1.0),
    materials: [PortalMaterial()]
  )

  var body: some View {
    GeometryReader3D { geometry in
      ZStack {
        RealityView { content in

          // The root for the content that will appear *inside* the portal
          let portalContentRoot = Entity()
          portalContentRoot.scale *= 0.5
          portalContentRoot.position.y -= 0.5
          portalContentRoot.components.set(WorldComponent())

          // We'll load some content to add to the portalContentRoot
          guard let scene = try? await Entity(named: "PortalSwapRed", in: realityKitContentBundle)
          else { return }
          portalContentRoot.addChild(scene)
          portalPlane.components.set(PortalComponent(target: portalContentRoot))

          rootEntity.addChild(portalContentRoot)
          rootEntity.addChild(portalPlane)
          content.add(rootEntity)
        } update: { content in
          // Resize the scene based on the size of the reality view content.
          // Based on the example from Apple https://developer.apple.com/documentation/visionos/displaying-a-3d-environment-through-a-portal
          let size = content.convert(geometry.size, from: .local, to: .scene)

          portalPlane.model?.mesh = .generatePlane(
            width: size.x, height: size.y, cornerRadius: 0.03)

        }
        .opacity(windowIsOpen ? 1.0 : 0.0)
        .frame(depth: 0.4)

        VStack {
          HStack {
            Text("Fruits")
              .font(.title)
              .frame(height: 60)
            Spacer()
            Button(
              action: {
                print("button pressed")
                  withAnimation(.easeInOut(duration: 0.3)) {
                      windowIsOpen.toggle()
                  }
              },
              label: {
                Text("Open Window")
              })
          }
          .padding(.horizontal, 24)
          .padding(.top, 12)
          List {
            Text("Apple")
            Text("Banana")
            Text("Orange")
          }
        }
        .glassBackgroundEffect()
        .offset(y: windowIsOpen ? -360 : 0)
      }
      .frame(width: geometry.size.width, height: geometry.size.height)
    }
  }

}

#Preview {
  Lab048()
}
