//
//  PhotoApprovalView.swift
//  Badgely
//
//  Created by Carolina Nicole Gonzalez Leal on 09/10/25.
//

import SwiftUI
import SwiftData

struct PhotoApprovalView: View {
    var place: Place
    let image: UIImage
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query var users: [User]
    
    @State private var showSaveConfirmation = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                    .padding()
                
                HStack(spacing: 40) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .font(.headline)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("Continuar") {
                        savePhoto()
                    }
                    .font(.headline)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
    }
    
    private func savePhoto() {
        let imageData = image.pngData()
        
        let newPhoto = Photo(name: "Photo from \(place.displayName)", photo: imageData!, badgeName: place.specialBadge)
        context.insert(newPhoto)
        
        if place.specialBadge != "" {
            users[0].specialBadges.append(place.specialBadge)
        }
        else {
            dismiss()
            return
        }
        
        try? context.save()
        dismiss()
    }
}
