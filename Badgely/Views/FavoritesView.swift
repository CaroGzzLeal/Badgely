//
//  BadgesView 2.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 08/10/25.
//


import SwiftUI

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var placesViewModel: PlacesViewModel
    @Bindable var user: User

    private var favoritePlaces: [Place] {
        placesViewModel.places
            .filter { user.favorites.contains($0.id) }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
    
    var body: some View {
        VStack {
            Text(user.name)
            Text(user.city)
            
            if user.favorites.isEmpty {
                Text("No favorites here")
                    .foregroundColor(.gray)
                    .italic()
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your Favorites:")
                        .font(.headline)
                    ForEach(favoritePlaces) { favorite in
                        Text("• \(favorite.name)")
                        Image(favorite.image)
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
        }
    }
}
