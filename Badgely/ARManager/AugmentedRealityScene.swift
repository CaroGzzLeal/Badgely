//
//  RealityViewScene.swift
//  Badgely
//
//  Created by Carolina Nicole Gonzalez Leal on 09/10/25.
//

import Foundation
import SwiftUI
import RealityKit
import ARKit

struct AugmentedRealityScene: UIViewRepresentable {
    var selectedBadges: [String]
    @Binding var arView: ARView?
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        DispatchQueue.main.async {
            self.arView = arView
        }
        
        guard ARFaceTrackingConfiguration.isSupported else {
            print("La cámara frontal no está disponible.")
            return arView
        }
        
        do {
            let scene = try Entity.load(named: "Scene")
            let faceAnchor = AnchorEntity(.face)
            faceAnchor.addChild(scene)
            arView.scene.addAnchor(faceAnchor)
            
            if let banda = scene.findEntity(named: "Banda") {
                
                banda.children.forEach { child in
                    child.isEnabled = false
                }
                
                for name in selectedBadges {
                    if let badgeEntity = banda.findEntity(named: name) {
                        badgeEntity.isEnabled = true
                    }
                    else {
                        print("No se encontró la entidad")
                    }
                }
                
                banda.position = SIMD3(x: 0, y: -0.3, z: 0.02)
                banda.scale = SIMD3(x: 2, y: 0.7, z: 0.1)
                banda.orientation = simd_quatf(angle: .pi / -5, axis: SIMD3<Float>(0, 0, 1))
            }
            else {
                print("No se encontró la entidad.")
            }
        }
        catch {
            print("Error al cargar la escena: \(error)")
        }
        
        let config = ARFaceTrackingConfiguration()
        config.isLightEstimationEnabled = true
        arView.environment.sceneUnderstanding.options.insert(.occlusion)
        
        arView.session.run(config)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}

