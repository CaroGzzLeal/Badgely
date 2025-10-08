//
//  PhotoView.swift
//  Badgely
//
//  Created by Carolina Nicole Gonzalez Leal on 07/10/25.
//

import SwiftUI
import RealityKit
import ARKit
import simd

// MARK: - ContentView principal
struct PhotoView: View {
    @State private var showAR = false
    @State private var capturedImage: UIImage?

    var body: some View {
        VStack {
            if let img = capturedImage {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 400)
                    .cornerRadius(12)
                    .shadow(radius: 6)
            } else {
                Text("No hay foto aún")
            }

            Button("Abrir cámara con corona") {
                showAR = true
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .fullScreenCover(isPresented: $showAR) {
            ARCameraSheet(isPresented: $showAR, capturedImage: $capturedImage)
        }
    }
}

// MARK: - Sheet full screen con ARView
struct ARCameraSheet: View {
    @Binding var isPresented: Bool
    @Binding var capturedImage: UIImage?

    var body: some View {
        ZStack {
            // ARFaceView recibe closure para capturar la foto
            ARFaceView { image in
                self.capturedImage = image
                self.isPresented = false
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: - UIViewRepresentable con ARFaceTracking y corona
struct ARFaceView: UIViewRepresentable {
    var onCapture: (UIImage) -> Void

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        context.coordinator.arView = arView

        // Configuración AR
        guard ARFaceTrackingConfiguration.isSupported else {
            print("ARFaceTracking no soportado en este dispositivo.")
            return arView
        }

        let config = ARFaceTrackingConfiguration()
        config.isLightEstimationEnabled = true
        arView.session.run(config)

        // Anchor para la cara
        let faceAnchor = AnchorEntity(.face)
        arView.scene.addAnchor(faceAnchor)
        context.coordinator.faceAnchor = faceAnchor

        // Cargar corona
        Task {
            do {
                let entity = try await Entity(named: "crown", in: Bundle.main)
                entity.position = [0, 0.18, -0.2]
                entity.scale = [0.01, 0.01, 0.01]
                entity.orientation = simd_quatf(angle: .pi + .pi / 2, axis: SIMD3<Float>(1, 0, 0))

                await MainActor.run {
                    faceAnchor.addChild(entity)
                }
            } catch {
                print("Error cargando crown:", error)
            }
        }

        // Agregar botón de captura sobre ARView directamente
        DispatchQueue.main.async {
            let button = UIButton(type: .system)
            button.frame = CGRect(x: (arView.bounds.width-70)/2, y: arView.bounds.height-100, width: 70, height: 70)
            button.layer.cornerRadius = 35
            button.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            button.setTitle("📸", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button.addTarget(context.coordinator, action: #selector(Coordinator.takePhoto), for: .touchUpInside)
            arView.addSubview(button)
        }

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) { }

    func makeCoordinator() -> Coordinator { Coordinator(onCapture: onCapture) }

    class Coordinator: NSObject {
        var arView: ARView?
        var faceAnchor: AnchorEntity?
        var onCapture: (UIImage) -> Void

        init(onCapture: @escaping (UIImage) -> Void) {
            self.onCapture = onCapture
        }

        @objc func takePhoto() {
            guard let arView = arView else { return }
            // Usamos el método clásico con closure
            arView.snapshot(saveToHDR: false) { image in
                if let img = image {
                    self.onCapture(img)
                }
            }
        }
    }
}

#Preview {
    PhotoView()
}
