//
//  PhotoCardView.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 09/11/25.
//
import SwiftUI
import SwiftData

struct PhotoCardView: View {
    let image: UIImage
    let title: String
    let place: Place?
    let user: User?
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Imagen
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 180, height: 260)
                .clipped()
            
            /*// Degradado inferior para que el texto se lea
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.0),
                    Color.white.opacity(0.8)
                ]),
                startPoint: .center,
                endPoint: .bottom
            )
            .frame(width: 180, height: 260)
            */
            HStack(alignment: .bottom) {
                
                // Badges como en PlaceDetailView
                if let place, let user {
                    HStack(spacing: -12) {
                        
                        if let responsible = place.responsibleBadge {
                            Image(responsible)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                                .opacity(user.responsibleBadges.contains(responsible) ? 1.0 : 0.2)
                            
                        
                        }
                        
                        Image(place.badge)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                            .opacity(user.badges.contains(place.badge) ? 1.0 : 0.2)
                    }
                }
            }
            .padding(10)
        }
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(
                    Color(colorScheme == .dark
                          ? Color(red: 28/255, green: 28/255, blue: 30/255)
                          : Color(red: 245/255, green: 245/255, blue: 245/255))
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
    }
}
