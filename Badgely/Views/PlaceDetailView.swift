//
//  PlaceDetailView.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 07/10/25.
//
import SwiftUI
import SwiftData

//Vista de detalle de cada place, cuando le haces click esto es lo que te muestra TO DO - DARLE DISEÑO
struct PlaceDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    @EnvironmentObject var placesViewModel: PlacesViewModel
    
    private var user: User? { users.first }
    private var isFavorite: Bool {
        user?.favorites.contains(place.id) ?? false
    }
    
    var place: Place
    var body: some View {
        VStack {
            Image(place.image)
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding()
            Text(place.displayName)
                .font(Font.largeTitle.bold())
            Text(place.description)
                .font(.subheadline)
            Text(place.address)
                .font(.subheadline)
            //if place.badge  {
            
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    toggleFavorite()
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .symbolRenderingMode(.hierarchical)
                }
                .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
            }
        }
    }
    
    private func toggleFavorite() {
        guard let user else { return }
        if let idx = user.favorites.firstIndex(of: place.id) {
            user.favorites.remove(at: idx)
        } else {
            user.favorites.append(place.id)
        }
        // SwiftData autosaves, but this is fine if you want to be explicit:
        try? modelContext.save()
    }
}
