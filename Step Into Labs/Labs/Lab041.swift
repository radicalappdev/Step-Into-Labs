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
            portalEntityFront.position = frontPosition
            portalEntityFront.transform.rotation = simd_quatf(angle: 0, axis: [0, 1, 0])
            portalEntityFront.components.set(PortalComponent(target: portalContentFront))
            portalEntityFront.model?.materials = [portalMaterial]
            portalEntityFront.components.set(InputTargetComponent())
            
            // Back portal to blue scene
            portalEntityBack.position = backPosition
            portalEntityBack.transform.rotation = simd_quatf(angle: 0, axis: [0, 1, 0])
            portalEntityBack.components.set(PortalComponent(target: portalContentBack))
            portalEntityBack.model?.materials = [portalMaterial]
            portalEntityBack.components.set(InputTargetComponent())
            
            // Disable occlusion
            occEntity.model?.materials = [disabledMaterial]
            occEntity.components.remove(InputTargetComponent.self)
            
        case .red:
            // Front portal to blue scene
            portalEntityFront.position = frontPosition
            portalEntityFront.transform.rotation = simd_quatf(angle: 0, axis: [0, 1, 0])
            portalEntityFront.components.set(PortalComponent(target: portalContentFront))
            portalEntityFront.model?.materials = [portalMaterial]
            portalEntityFront.components.set(InputTargetComponent())
            
            // Back portal as occlusion
            portalEntityBack.position = backPosition
            portalEntityBack.transform.rotation = simd_quatf(angle: .pi, axis: [0, 1, 0])
            portalEntityBack.components.remove(PortalComponent.self)
            portalEntityBack.model?.materials = [occlusionMaterial]
            portalEntityBack.components.set(InputTargetComponent())
            
            // Disable middle portal
            occEntity.model?.materials = [disabledMaterial]
            occEntity.components.remove(InputTargetComponent.self)
            
        case .blue:
            // Front portal as occlusion
            portalEntityFront.position = frontPosition
            portalEntityFront.transform.rotation = simd_quatf(angle: 0, axis: [0, 1, 0])
            portalEntityFront.components.remove(PortalComponent.self)
            portalEntityFront.model?.materials = [occlusionMaterial]
            portalEntityFront.components.set(InputTargetComponent())
            
            // Back portal to red scene
            portalEntityBack.position = backPosition
            portalEntityBack.transform.rotation = simd_quatf(angle: 0, axis: [0, 1, 0])
            portalEntityBack.components.set(PortalComponent(target: portalContentBack))
            portalEntityBack.model?.materials = [portalMaterial]
            portalEntityBack.components.set(InputTargetComponent())
            
            // Disable middle portal
            occEntity.model?.materials = [disabledMaterial]
            occEntity.components.remove(InputTargetComponent.self)
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

            // Front portal
            portalContentFront.addChild(redScene)
            portalContentFront.components.set(WorldComponent())

            portalEntityFront.name = "Front"
            portalEntityFront.position = frontPosition
            portalEntityFront.components.set(PortalComponent(target: portalContentFront))

            let portalCollisionFront = CollisionComponent(shapes: [.generateBox(width: 0.8, height: 2, depth: 0.05)])
            portalEntityFront.components.set(portalCollisionFront)
            portalEntityFront.components.set(InputTargetComponent())
            rootEntity.addChild(portalEntityFront)

            // Back portal
            portalContentBack.addChild(blueScene)
            portalContentBack.components.set(WorldComponent())

            portalEntityBack.name = "Back"
            portalEntityBack.position = backPosition
            portalEntityBack.components.set(PortalComponent(target: portalContentBack))

            let portalCollisionBack = CollisionComponent(shapes: [.generateBox(width: 0.8, height: 2, depth: 0.05)])
            portalEntityBack.components.set(portalCollisionBack)
            portalEntityBack.components.set(InputTargetComponent())
            rootEntity.addChild(portalEntityBack)

            // Call updatePortalStates to set initial state
            updatePortalStates()
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
                        currentScene = .red
                        outerContent.children.removeAll()
                        outerContent.addChild(redScene)
                        
                        portalContentFront.children.removeAll()
                        portalContentFront.addChild(blueScene)
                        portalContentBack.children.removeAll()
                        
                    } else if tappedEntity == portalEntityBack {
                        currentScene = .blue
                        outerContent.children.removeAll()
                        outerContent.addChild(blueScene)
                        
                        portalContentFront.children.removeAll()
                        portalContentBack.children.removeAll()
                        portalContentBack.addChild(redScene)
                    }
                    
                case .red:
                    if tappedEntity == portalEntityFront {
                        currentScene = .blue
                        outerContent.children.removeAll()
                        outerContent.addChild(blueScene)
                        
                        portalContentFront.children.removeAll()
                        portalContentBack.children.removeAll()
                        portalContentBack.addChild(redScene)
                        
                    } else if tappedEntity == portalEntityBack {
                        currentScene = .passthrough
                        outerContent.children.removeAll()
                        
                        portalContentFront.children.removeAll()
                        portalContentFront.addChild(redScene)
                        portalContentBack.children.removeAll()
                        portalContentBack.addChild(blueScene)
                    }
                    
                case .blue:
                    if tappedEntity == portalEntityFront {
                        currentScene = .passthrough
                        outerContent.children.removeAll()
                        
                        portalContentFront.children.removeAll()
                        portalContentFront.addChild(redScene)
                        portalContentBack.children.removeAll()
                        portalContentBack.addChild(blueScene)
                        
                    } else if tappedEntity == portalEntityBack {
                        currentScene = .red
                        outerContent.children.removeAll()
                        outerContent.addChild(redScene)
                        
                        portalContentFront.children.removeAll()
                        portalContentFront.addChild(blueScene)
                        portalContentBack.children.removeAll()
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
