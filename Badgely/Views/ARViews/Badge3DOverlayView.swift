//
//  Badge3DOverlayView.swift
//  Badgely
//
//  Created by Badgely AI on 08/11/25.
//

import SwiftUI
import SceneKit

/// Custom SceneView with configurable background
struct CustomSceneView: UIViewRepresentable {
    let scene: SCNScene
    let backgroundColor: UIColor
    
    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()
        view.scene = scene
        view.allowsCameraControl = true
        view.autoenablesDefaultLighting = true
        view.backgroundColor = backgroundColor
        return view
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {}
}

/// Displays a 3D model or image of an earned badge in an overlay
struct Badge3DOverlayView: View {
    let badgeName: String
    let badgeDisplayName: String
    let isLastBadge: Bool
    let onContinue: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    // Available 3D models
    private let available3DModels: Set<String> = [
        "frecuente_36",
        "frecuente_37",
        "frecuente_38",
        "frecuente_39",
        "termo_50"
    ]
    
    private var has3DModel: Bool {
        available3DModels.contains(badgeName)
    }
    
    var body: some View {
        ZStack {
            // Semi-transparent black background
            Color.black.opacity(0.85)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Title
                Text(isLastBadge ? "¡Insignia especial desbloqueada!" : "¡Has ganado una nueva insignia!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Badge visualization (3D model or image)
                if has3DModel {
                    CustomSceneView(
                        scene: load3DModel(),
                        backgroundColor: UIColor.clear.withAlphaComponent(1)
                    )
                    .frame(width: 300, height: 300)
                    .background(Color.clear.opacity(1))
                    .cornerRadius(20)
                } else {
                    // Fallback to badge image
                    Image(badgeName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 280, height: 280)
                        )
                }
                
                // Badge name
                Text(badgeDisplayName)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Description
                Text(isLastBadge ? "¡Increíble trabajo!" : "¡Felicidades!")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                
                // Action button
                Button(action: onContinue) {
                    Text(isLastBadge ? "Aceptar" : "Continuar")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: 200)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 30/255, green: 94/255, blue: 54/255))
                        )
                }
                .padding(.top, 10)
            }
            .padding()
        }
    }
    
    /// Loads the 3D model from the bundle
    private func load3DModel() -> SCNScene {
        guard let modelURL = Bundle.main.url(forResource: badgeName, withExtension: "usdz"),
              let scene = try? SCNScene(url: modelURL) else {
            // Return empty scene if model can't be loaded
            return SCNScene()
        }
        
        // Configure scene lighting and camera
        scene.background.contents = UIColor.clear
        
        // Add ambient light
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.intensity = 800
        scene.rootNode.addChildNode(ambientLight)
        
        // Add directional light
        let directionalLight = SCNNode()
        directionalLight.light = SCNLight()
        directionalLight.light?.type = .directional
        directionalLight.light?.intensity = 1000
        directionalLight.position = SCNVector3(x: 0, y: 5, z: 5)
        directionalLight.eulerAngles = SCNVector3(x: -.pi / 4, y: 0, z: 0)
        scene.rootNode.addChildNode(directionalLight)
        
        // Center and scale the model
        let (minVec, maxVec) = scene.rootNode.boundingBox
        let modelSize = maxVec - minVec
        let maxDimension = max(modelSize.x, max(modelSize.y, modelSize.z))
        let scale = 2.0 / CGFloat(maxDimension)
        scene.rootNode.scale = SCNVector3(scale, scale, scale)
        
        // Center the model
        let center = (minVec + maxVec) * 0.5
        scene.rootNode.position = SCNVector3(-center.x * Float(scale), -center.y * Float(scale), -center.z * Float(scale))
        
        return scene
    }
}

// Helper extensions for SCNVector3 operations
extension SCNVector3 {
    static func -(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
    }
    
    static func +(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }
    
    static func *(lhs: SCNVector3, rhs: Float) -> SCNVector3 {
        return SCNVector3(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs)
    }
}

#Preview {
    Badge3DOverlayView(
        badgeName: "frecuente_36",
        badgeDisplayName: "Cliente Frecuente",
        isLastBadge: false,
        onContinue: {}
    )
}
