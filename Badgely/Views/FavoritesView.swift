//
//  BadgesView 2.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 08/10/25.
//


import SwiftUI

/*struct FavoritesView: View {
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
*/


struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var placesViewModel: PlacesViewModel
    
    @Bindable var user: User
    
    private var favoritePlaces: [Place] {
        placesViewModel.places
            .filter { user.favorites.contains($0.id) }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
    
    
    let rows = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    
    var body: some View {
        ZStack{
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .allowsHitTesting(false)
            
            VStack {
                //Text(user.name)
                //Text(user.city)
                
                
                if user.favorites.isEmpty {
                    Text("Aún no tienes favoritos.")
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    
                    ZStack{
                        VStack(spacing: 15) {
                            Text("Favoritos para tu Viaje")
                                .padding(.top, 60)
                                .foregroundStyle(.black)
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                                .font(.custom("SF Pro", size: 24))
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            ScrollView(.vertical, showsIndicators: false) {
                                //LazyVGrid(rows: rows) {
                                    ForEach(favoritePlaces) { favorite in
                                        NavigationLink(destination: PlaceDetailView(place: favorite)) {
                                            
                                            CardView(place: favorite)
                                                .padding(.bottom, 20)
                                                .frame(maxWidth: .infinity, alignment: .center)
                                        }
                                    }
                                    
                                //}
                                
                            }

                            
                        }//VStack
                    }//ZStack
                }//else
            } //VStack
        } //ZStack
    }// body
} //view
