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
    
    @State private var showCommonBadgeAlert = false
    @State private var showSpecialBadgeAlert = false
    @State private var earnedBadgeName: String = ""
    @State private var earnedSpecialBadgeName: String?
    
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
        .alert("¡Has ganado una nueva insignia!", isPresented: $showCommonBadgeAlert) {
            Button("Continuar") {
                if earnedSpecialBadgeName != nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        showSpecialBadgeAlert = true
                    }
                } else {
                    dismiss()
                }
            }
        } message: {
            Text("Has obtenido la insignia \(earnedBadgeName). ¡Felicidades!")
        }
        .alert("¡Insignia especial desbloqueada!", isPresented: $showSpecialBadgeAlert) {
            Button("Aceptar") {
                dismiss()
            }
        } message: {
            if let special = earnedSpecialBadgeName {
                Text("Has obtenido la insignia especial \(special). ¡Increíble trabajo!")
            }
        }
    }
    
    private func savePhoto() {
        guard let imageData = image.pngData(), let user = users.first else { return }
        
        let newPhoto = Photo(
           name: place.displayName,
           photo: imageData,
           badgeName: place.badge,
           place: place.address
       )
       context.insert(newPhoto)
        
        if !user.badges.contains(place.badge) {
            user.badges.append(place.badge)
            earnedBadgeName = place.displayName
        }
        
        if user.badges.contains(place.badge) {
            user.responsibleBadges.append(place.responsibleBadge!)
            earnedBadgeName = place.responsibleBadge!
        }
        
        user.comunBadges[place.type, default: 0] += 1
        let visits = user.comunBadges[place.type] ?? 0
        
        if visits == 3 {
            let special = "frecuente_\(36 + categoryOffset(for: place.type))"
            if !user.specialBadges.contains(special) {
                user.specialBadges.append(special)
                earnedSpecialBadgeName = "de cliente frecuente"
            }
        } else if visits == 5 {
            let special = "maximo_\(43 + categoryOffset(for: place.type))"
            if !user.specialBadges.contains(special) {
                user.specialBadges.append(special)
                earnedSpecialBadgeName = "de cliente máximo"
            }
        }
        
        try? context.save()
        showCommonBadgeAlert = true
    }
    
    private func categoryOffset(for type: String) -> Int {
        switch type {
        case "cafeteria": return 0
        case "restaurante": return 1
        case "emblematico": return 2
        case "vidaNocturna": return 3
        case "eventos": return 4
        case "voluntariado": return 5
        default: return 6
        }
    }
}
