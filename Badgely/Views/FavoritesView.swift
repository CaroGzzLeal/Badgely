//
//  BadgesView 2.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 08/10/25.
//


import SwiftUI
import SwiftData

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
    
    @Environment(\.colorScheme) var colorScheme

    @Query private var users: [User]

    @Bindable var user: User
    
    private var favoritePlaces: [Place] {
        placesViewModel.places
            .filter { user.favorites.contains($0.id) }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
    
    var body: some View {
        NavigationStack {
            ZStack{
                Image(colorScheme == .dark ? "backgroundDarkmode" : "background" )
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                
                VStack {

                    if user.favorites.isEmpty {
                        Text("Aún no tienes favoritos.")
                            .foregroundColor(.gray)
                            .italic()
                    } else {
                        
                        ZStack{
                            
                            VStack() {
                                Spacer()
                                ScrollView(.vertical, showsIndicators: false) {
                                    Text("Tus Favoritos")
                                        .padding(.top, 100)
                                        .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                                        .fontWeight(.bold)
                                        .font(.system(size: 32))
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .font(.title).bold()
                                    
                                    VStack {
                                        ScrollView() {
                                            ForEach(favoritePlaces) { place in
                                                NavigationLink(destination: PlaceDetailView(place: place)) {
                                                    CardView(width: 300, height: 180, place: place)
                                                        .padding(20)
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                                
                                
                            }//VStack
                        }//ZStack
                    }//else
                } //VStack
            } //ZStack
            .navigationTitle(users.first?.city ?? "Badgely")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        
                        Text(users.first?.city ?? "Badgely")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(Color(colorScheme == .dark ? .white : .black))
                        
                        Image(systemName: "location")
                            .foregroundColor(Color(colorScheme == .dark ? .white : .black).opacity(0.8))
                            .font(.system(size: 18))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(colorScheme == .dark ? .white : .black), lineWidth: 2)
                            .shadow(radius: 4)
                    )
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }

    }
}
