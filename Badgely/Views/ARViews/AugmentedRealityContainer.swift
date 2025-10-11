//
//  AugmentedRealityContainer.swift
//  Badgely
//
//  Created by Carolina Nicole Gonzalez Leal on 09/10/25.
//

import SwiftUI
import ARKit
import RealityKit

struct AugmentedRealityContainer: View {
    var place: Place
    var selectedBadges: [String]
    @Binding var showCamera: Bool
    @State private var capturedImage: UIImage? = nil
    @State private var arView: ARView? = nil
    @State private var showPreview = false
    
    var body: some View {
        ZStack {
            AugmentedRealityScene(selectedBadges: selectedBadges, arView: $arView)
                .ignoresSafeArea()
                .overlay(alignment: .bottom) {
                    Button(action: {
                        captureSnapshot()
                    }) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showCamera = false
                    }, label: {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .padding()
                            .frame(alignment: .topTrailing)
                    })
                }
                Spacer()
            }
            
            if let capturedImage {
                PhotoApprovalView(place: place, image: capturedImage)
                    .transition(.opacity)
            }
        }
    }
    private func captureSnapshot() {
        guard let arView
        else {
            print("No se encontró el ARView.")
            return
        }
        
        arView.snapshot(saveToHDR: false) { image in
            guard let image = image
            else {
                print("No se pudo capturar la imagen.")
                return
            }
            
            capturedImage = image
            withAnimation {
                showPreview = true
            }
        }
    }
}
