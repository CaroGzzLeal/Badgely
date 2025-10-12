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
                                    Text("¡Tus Favoritos!")
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
            .sheet(isPresented: $showLocationPicker) {
                if let user = users.first {
                    LocationPickerView(user: user, placesViewModel: placesViewModel)
                }
            }
            .onAppear {
                // Load places for user's city when view appears
                if let city = users.first?.city {
                    placesViewModel.loadPlaces(for: city)
                }
            }
            .onChange(of: users.first?.city) { oldValue, newValue in
                // Reload places when city changes
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
