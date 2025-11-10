//
//  Badge3DOverlayView.swift
//  Badgely
//
//  Created by Martha Mendoza on 08/11/25.
//

import SwiftUI
import SceneKit

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

struct Badge3DOverlayView: View {
    let badgeName: String
    let badgeDisplayName: String
    let isLastBadge: Bool
    let onContinue: () -> Void
    
    
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
            Color.black.opacity(0.85)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text(isLastBadge ? "¡Insignia especial desbloqueada!" : "¡Has ganado una nueva insignia!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                if has3DModel {
                    CustomSceneView(
                        scene: load3DModel(),
                        backgroundColor: UIColor.clear
                    )
                    .frame(width: 400, height: 400)
                    .background(Color.clear.opacity(1))
                    .padding(.leading, 40)
                } else {
                    Image(badgeName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                }
                
                Text(badgeDisplayName)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text(isLastBadge ? "¡Increíble trabajo!" : "¡Felicidades!")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                
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
    
    private func load3DModel() -> SCNScene {
        guard let modelURL = Bundle.main.url(forResource: badgeName, withExtension: "usdz"),
              let scene = try? SCNScene(url: modelURL) else {
            return SCNScene()
        }
        
        scene.background.contents = UIColor.clear
        
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.intensity = 800
        scene.rootNode.addChildNode(ambientLight)
        
        let directionalLight = SCNNode()
        directionalLight.light = SCNLight()
        directionalLight.light?.type = .directional
        directionalLight.light?.intensity = 1000
        directionalLight.position = SCNVector3(x: 0, y: 0, z: 0)
        directionalLight.eulerAngles = SCNVector3(x: -.pi / 4, y: 0, z: 0)
        scene.rootNode.addChildNode(directionalLight)
        
        let (minVec, maxVec) = scene.rootNode.boundingBox
        let modelSize = maxVec - minVec
        let maxDimension = max(modelSize.x, max(modelSize.y, modelSize.z))
        let scale = 2.0 / CGFloat(maxDimension)
        scene.rootNode.scale = SCNVector3(scale, scale, scale)
        
        let center = (minVec + maxVec) * 0.5
        scene.rootNode.position = SCNVector3(-center.x * Float(scale), -center.y * Float(scale), -center.z * Float(scale))
        scene.rootNode.rotation = SCNVector4(0, 1, 0, -Swift.Double.pi / 2)

        return scene
    }
}

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
