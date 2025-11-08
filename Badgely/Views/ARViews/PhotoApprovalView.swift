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
    @Environment(\.colorScheme) var colorScheme
    
    // Badge overlay states
    @State private var showBadgeOverlay = false
    @State private var currentBadgeIndex = 0
    @State private var earnedBadges: [(name: String, displayName: String)] = []
    
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
                    .font(.system(size: 20, weight: .semibold))
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(
                            Color(colorScheme == .dark
                                  ? Color(red: 175/255, green: 76/255, blue: 79/255) // #AF4C4F
                                  : Color(red: 175/255, green: 76/255, blue: 79/255))
                        )
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    
                    Button("Continuar") {
                        savePhoto()
                    }
                    .font(.system(size: 20, weight: .semibold))
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(
                            Color(colorScheme == .dark
                                  ? Color(red: 76/255, green: 175/255, blue: 80/255) // #4CAF50
                                  : Color(red: 76/255, green: 175/255, blue: 80/255))
                        )
                    .foregroundColor(.white)
                    .cornerRadius(20)
                }
            }
            
            // 3D Badge Overlay
            if showBadgeOverlay && !earnedBadges.isEmpty {
                Badge3DOverlayView(
                    badgeName: earnedBadges[currentBadgeIndex].name,
                    badgeDisplayName: earnedBadges[currentBadgeIndex].displayName,
                    isLastBadge: currentBadgeIndex == earnedBadges.count - 1,
                    onContinue: handleBadgeOverlayContinue
                )
                .transition(.opacity.combined(with: .scale))
                .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showBadgeOverlay)
        .animation(.easeInOut(duration: 0.3), value: currentBadgeIndex)
    }
    
    /// Handles the continue/dismiss action from the badge overlay
    private func handleBadgeOverlayContinue() {
        if currentBadgeIndex < earnedBadges.count - 1 {
            // Show next badge
            currentBadgeIndex += 1
        } else {
            // Last badge - dismiss completely
            dismiss()
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
        
        // Collect all earned badges
        earnedBadges.removeAll()
        
        // Check for regular badge
        if !user.badges.contains(place.badge) {
            user.badges.append(place.badge)
            earnedBadges.append((name: place.badge, displayName: place.displayName))
        }
        
        // Check for responsible badge
        if let responsibleBadge = place.responsibleBadge,
           !responsibleBadge.isEmpty,
           user.badges.contains(place.badge) {
            user.responsibleBadges.append(responsibleBadge)
            earnedBadges.append((name: responsibleBadge, displayName: "Insignia Responsable"))
        }
        
        // Update community badges and check for special badges
        user.comunBadges[place.type, default: 0] += 1
        let visits = user.comunBadges[place.type] ?? 0
        
        if visits == 3 {
            let special = "frecuente_\(36 + categoryOffset(for: place.type))"
            if !user.specialBadges.contains(special) {
                user.specialBadges.append(special)
                earnedBadges.append((name: special, displayName: "Cliente Frecuente"))
            }
        } else if visits == 5 {
            let special = "maximo_\(43 + categoryOffset(for: place.type))"
            if !user.specialBadges.contains(special) {
                user.specialBadges.append(special)
                earnedBadges.append((name: special, displayName: "Cliente Máximo"))
            }
        }
        
        // Save context
        try? context.save()
        
        // Show badge overlay if any badges were earned
        if !earnedBadges.isEmpty {
            currentBadgeIndex = 0
            showBadgeOverlay = true
        } else {
            // No new badges, just dismiss
            dismiss()
        }
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
