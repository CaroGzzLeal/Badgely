//
//  BadgesView 2.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 08/10/25.
//


import SwiftUI
import SwiftData


struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var placesViewModel: PlacesViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showLocationPicker = false

    @Query private var users: [User]

    @Bindable var user: User
    
    private var favoritePlaces: [Place] {
        placesViewModel.places
            .filter { user.favorites.contains($0.id) }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(colorScheme == .dark ? "backgroundDarkmode" : "background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                
                VStack {
                    if user.favorites.isEmpty {
                        
                        VStack {
                            Spacer()
                            
                            VStack(spacing: 16) {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray)
                                Text("Aún no tienes favoritos.")
                                    .foregroundColor(.gray)
                                    .italic()
                            }
                            
                            Spacer()
                        }
                        .frame(minHeight: 500)
                        
                        
                    } else {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 20) {
                                Text("¡Tus Favoritos!")
                                    .padding(.top, 100)
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                    .font(.system(size: 32, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                ForEach(favoritePlaces) { place in
                                    NavigationLink(destination: PlaceDetailView(place: place)) {
                                        CardView(width: 300, height: 180, place: place)
                                    }
                                }
                                
                                Spacer(minLength: 100) //helps ensure last card isn’t cut off
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
 //ZStack
            .sheet(isPresented: $showLocationPicker) {
                if let user = users.first {
                    LocationPickerView(user: user, placesViewModel: placesViewModel)
                }
            }
            .onAppear {
                // Cargar lugares de la ciudad del user
                if let city = users.first?.city {
                    placesViewModel.loadPlaces(for: city)
                }
            }
            .onChange(of: users.first?.city) { oldValue, newValue in
                // reload si city cambia
                if let city = newValue {
                    placesViewModel.loadPlaces(for: city)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    if #available(iOS 26.0, *) {
                        Button {
                            showLocationPicker.toggle()
                        } label: {
                            HStack(spacing: 4) {
                                Text(users.first?.city ?? "Badgely")
                                    .font(.system(size: 18, weight: .bold))
                                Image(systemName: "location")
                                    .font(.system(size: 18, weight: .bold))
                            }
                        }
                        .padding(10)
                        .glassEffect()
                    } else {
                        Button {
                            showLocationPicker.toggle()
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "location")
                                Text(users.first?.city ?? "Badgely")
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            
        }

    }
}
