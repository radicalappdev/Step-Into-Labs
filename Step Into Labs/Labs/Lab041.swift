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

    // Add materials as properties for easy access
    private let portalMaterial = PortalMaterial()
    private let occlusionMaterial = OcclusionMaterial()
    private let disabledMaterial = SimpleMaterial(color: .clear, isMetallic: false)
    
    // Add constants for portal positioning
    private let frontPosition: SIMD3<Float> = [0, 1, -0.99]  // Slightly in front of doorway
    private let backPosition: SIMD3<Float> = [0, 1, -1.01]   // Slightly behind doorway
    
    // Helper function to update portal states and positions
    private func updatePortalStates() {
        switch currentScene {
        case .passthrough:
            // Front portal to red scene
            portalEntityFront.transform.rotation = simd_quatf(angle: 0, axis: [0, 1, 0])  // Face forward
            portalEntityFront.position = frontPosition
            portalEntityFront.components.set(PortalComponent(target: portalContentFront))
            portalEntityFront.model?.materials = [portalMaterial]
            portalEntityFront.components.set(InputTargetComponent())
            portalContentFront.children.removeAll()
            portalContentFront.addChild(sceneRed!)  // Show red through front
            
            // Back portal to blue scene
            portalEntityBack.transform.rotation = simd_quatf(angle: .pi, axis: [0, 1, 0])  // Face backward
            portalEntityBack.position = backPosition
            portalEntityBack.components.set(PortalComponent(target: portalContentBack))
            portalEntityBack.model?.materials = [portalMaterial]
            portalEntityBack.components.set(InputTargetComponent())
            portalContentBack.children.removeAll()
            portalContentBack.addChild(sceneBlue!)  // Show blue through back
            
        case .red:
            // Front portal to blue scene
            portalEntityFront.transform.rotation = simd_quatf(angle: 0, axis: [0, 1, 0])  // Face forward
            portalEntityFront.position = frontPosition
            portalEntityFront.components.set(PortalComponent(target: portalContentFront))
            portalEntityFront.model?.materials = [portalMaterial]
            portalEntityFront.components.set(InputTargetComponent())
            portalContentFront.children.removeAll()
            portalContentFront.addChild(sceneBlue!)  // Show blue through front
            
            // Back portal as occlusion
            portalEntityBack.transform.rotation = simd_quatf(angle: .pi, axis: [0, 1, 0])  // Face backward
            portalEntityBack.position = backPosition
            portalEntityBack.components.remove(PortalComponent.self)
            portalEntityBack.model?.materials = [occlusionMaterial]
            portalEntityBack.components.set(InputTargetComponent())
            portalContentBack.children.removeAll()
            
        case .blue:
            // Front portal as occlusion
            portalEntityFront.transform.rotation = simd_quatf(angle: 0, axis: [0, 1, 0])  // Face forward
            portalEntityFront.position = frontPosition
            portalEntityFront.components.remove(PortalComponent.self)
            portalEntityFront.model?.materials = [occlusionMaterial]
            portalEntityFront.components.set(InputTargetComponent())
            portalContentFront.children.removeAll()
            
            // Back portal to red scene
            portalEntityBack.transform.rotation = simd_quatf(angle: .pi, axis: [0, 1, 0])  // Face backward
            portalEntityBack.position = backPosition
            portalEntityBack.components.set(PortalComponent(target: portalContentBack))
            portalEntityBack.model?.materials = [portalMaterial]
            portalEntityBack.components.set(InputTargetComponent())
            portalContentBack.children.removeAll()
            portalContentBack.addChild(sceneRed!)  // Show red through back
        }
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

            // Front portal - RED SCENE
            portalContentFront.components.set(WorldComponent())
            portalContentFront.children.removeAll()
            portalContentFront.addChild(redScene)  // RED in front

            portalEntityFront.name = "Front"
            portalEntityFront.position = frontPosition
            portalEntityFront.transform.rotation = simd_quatf(angle: 0, axis: [0, 1, 0])  // Face forward
            portalEntityFront.components.set(PortalComponent(target: portalContentFront))
            portalEntityFront.components.set(CollisionComponent(shapes: [.generateBox(width: 0.8, height: 2, depth: 0.05)]))
            portalEntityFront.components.set(InputTargetComponent())
            rootEntity.addChild(portalEntityFront)

            // Back portal - BLUE SCENE
            portalContentBack.components.set(WorldComponent())
            portalContentBack.children.removeAll()
            portalContentBack.addChild(blueScene)  // BLUE in back

            portalEntityBack.name = "Back"
            portalEntityBack.position = backPosition
            portalEntityBack.transform.rotation = simd_quatf(angle: .pi, axis: [0, 1, 0])  // Rotate 180 degrees to face back
            portalEntityBack.components.set(PortalComponent(target: portalContentBack))
            portalEntityBack.components.set(CollisionComponent(shapes: [.generateBox(width: 0.8, height: 2, depth: 0.05)]))
            portalEntityBack.components.set(InputTargetComponent())
            rootEntity.addChild(portalEntityBack)
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
                        // Tapped front portal - enter red scene
                        currentScene = .red
                        outerContent.children.removeAll()
                        outerContent.addChild(redScene)
                    } else if tappedEntity == portalEntityBack {
                        // Tapped back portal - enter blue scene
                        currentScene = .blue
                        outerContent.children.removeAll()
                        outerContent.addChild(blueScene)
                    }
                    
                case .red:
                    if tappedEntity == portalEntityFront {
                        // Tapped front portal - enter blue scene
                        currentScene = .blue
                        outerContent.children.removeAll()
                        outerContent.addChild(blueScene)
                    } else if tappedEntity == portalEntityBack {
                        // Tapped back occlusion - return to passthrough
                        currentScene = .passthrough
                        outerContent.children.removeAll()
                    }
                    
                case .blue:
                    if tappedEntity == portalEntityFront {
                        // Tapped front occlusion - return to passthrough
                        currentScene = .passthrough
                        outerContent.children.removeAll()
                    } else if tappedEntity == portalEntityBack {
                        // Tapped back portal - enter red scene
                        currentScene = .red
                        outerContent.children.removeAll()
                        outerContent.addChild(redScene)
                    }
                }
                
                // Update portal states after scene change
                updatePortalStates()
            }
    }
}

#Preview {
    Lab041()
}
