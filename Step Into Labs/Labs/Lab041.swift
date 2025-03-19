//  Step Into Vision - Labs
//
//  Title: Lab041
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 3/19/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab041: View {

    @State var outerContent = Entity()
    @State var portalContentFront = Entity()
    @State var portalContentBack = Entity()

    @State var portalEntityFront = ModelEntity(
        mesh: .generatePlane(width: 0.8, height: 2, cornerRadius: 0.01),
        materials: [PortalMaterial()]
    )

    @State var portalEntityBack = ModelEntity(
        mesh: .generatePlane(width: 0.8, height: 2, cornerRadius: 0.01),
        materials: [PortalMaterial()]
    )

    @State var occEntity = ModelEntity(
        mesh: .generatePlane(width: 0.8, height: 2, cornerRadius: 0.01),
        materials: [OcclusionMaterial()]
    )

    // Add state to store scene references
    @State private var sceneRed: Entity?
    @State private var sceneBlue: Entity?
    
    // Add state to track current scene
    @State private var currentScene: SceneType = .passthrough
    
    // Add enum to track scene types
    private enum SceneType {
        case passthrough
        case red
        case blue
    }

    var body: some View {
        RealityView { content in
            guard let doorway = try? await Entity(named: "PortalDoorway", in: realityKitContentBundle) else { return }
            guard let redScene = try? await Entity(named: "PortalSwapRed", in: realityKitContentBundle) else { return }
            guard let blueScene = try? await Entity(named: "PortalSwapBlue", in: realityKitContentBundle) else { return }
            
            // Store references to scenes
            sceneRed = redScene
            sceneBlue = blueScene

            let rootEntity = Entity()
            content.add(rootEntity)

            rootEntity.addChild(doorway)
            rootEntity.addChild(outerContent)
            rootEntity.addChild(portalContentFront)
            rootEntity.addChild(portalContentBack)
            rootEntity.addChild(occEntity)

            // Front portal
            portalContentFront.addChild(redScene)
            portalContentFront.components.set(WorldComponent())

            portalEntityFront.name = "Front"
            portalEntityFront.position = [-1.2, 1, -0.99]
            portalEntityFront.components.set(PortalComponent(target: portalContentFront))

            let portalCollisionFront = CollisionComponent(shapes: [.generateBox(width: 0.8, height: 2, depth: 0.05)])
            portalEntityFront.components.set(portalCollisionFront)
            portalEntityFront.components.set(InputTargetComponent())
            rootEntity.addChild(portalEntityFront)

            // Back portal
            portalContentBack.addChild(blueScene)
            portalContentBack.components.set(WorldComponent())

            portalEntityBack.name = "Back"
            portalEntityBack.position = [1.2, 1, -0.99]
            portalEntityBack.components.set(PortalComponent(target: portalContentBack))

            let portalCollisionBack = CollisionComponent(shapes: [.generateBox(width: 0.8, height: 2, depth: 0.05)])
            portalEntityBack.components.set(portalCollisionBack)
            portalEntityBack.components.set(InputTargetComponent())
            rootEntity.addChild(portalEntityBack)

            occEntity.name = "Occlusion"
            occEntity.position = [0, 1, -1.01]
//            occEntity.transform.rotation = simd_quatf(angle: .pi , axis: [0, 1, 0])
            let occCollision = CollisionComponent(shapes: [.generateBox(width: 0.8, height: 2, depth: 0.05)])
            occEntity.components.set(occCollision)
            occEntity.components.set(InputTargetComponent())
        }
        .gesture(doubleTap)
        .modifier(DragGestureImproved())
    }

    var doubleTap: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                guard let redScene = sceneRed, let blueScene = sceneBlue else { return }
                let tappedEntity = value.entity
                
                switch currentScene {
                case .passthrough:
                    if tappedEntity == portalEntityFront {
                        // Tapped front portal (red scene)
                        currentScene = .red
                        outerContent.children.removeAll()
                        outerContent.addChild(redScene)
                        
                        // Update portals for red scene
                        portalContentFront.children.removeAll()
                        portalContentFront.addChild(blueScene)
                        portalContentBack.children.removeAll()
                        
                    } else if tappedEntity == portalEntityBack {
                        // Tapped back portal (blue scene)
                        currentScene = .blue
                        outerContent.children.removeAll()
                        outerContent.addChild(blueScene)
                        
                        // Update portals for blue scene
                        portalContentFront.children.removeAll()
                        portalContentBack.children.removeAll()
                        portalContentBack.addChild(redScene)
                    }
                    
                case .red:
                    if tappedEntity == portalEntityFront {
                        // Tapped front portal (to blue scene)
                        currentScene = .blue
                        outerContent.children.removeAll()
                        outerContent.addChild(blueScene)
                        
                        // Update portals for blue scene
                        portalContentFront.children.removeAll()
                        portalContentBack.children.removeAll()
                        portalContentBack.addChild(redScene)
                        
                    } else if tappedEntity == portalEntityBack {
                        // Tapped back portal (occlusion)
                        currentScene = .passthrough
                        outerContent.children.removeAll()
                        
                        // Reset portals to initial state
                        portalContentFront.children.removeAll()
                        portalContentFront.addChild(redScene)
                        portalContentBack.children.removeAll()
                        portalContentBack.addChild(blueScene)
                    }
                    
                case .blue:
                    if tappedEntity == portalEntityFront {
                        // Tapped front portal (occlusion)
                        currentScene = .passthrough
                        outerContent.children.removeAll()
                        
                        // Reset portals to initial state
                        portalContentFront.children.removeAll()
                        portalContentFront.addChild(redScene)
                        portalContentBack.children.removeAll()
                        portalContentBack.addChild(blueScene)
                        
                    } else if tappedEntity == portalEntityBack {
                        // Tapped back portal (to red scene)
                        currentScene = .red
                        outerContent.children.removeAll()
                        outerContent.addChild(redScene)
                        
                        // Update portals for red scene
                        portalContentFront.children.removeAll()
                        portalContentFront.addChild(blueScene)
                        portalContentBack.children.removeAll()
                    }
                }
            }
    }
}

#Preview {
    Lab041()
}
