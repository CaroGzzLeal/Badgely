//
//  ContentView.swift
//  Badgely
//
//  Created by Carolina Nicole Gonzalez Leal on 06/10/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject private var locationManager: LocationManager
    
    @State private var navigate = false
    @State private var searchText = ""
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var users: [User]
    
    //@ObservedObject var user: User
    
    let emojiData = EmojiData.examples()
    
    @State private var showLocationPicker = false
    
    //let places: [Place] = Bundle.main.decode("places2.json")
    @EnvironmentObject var placesViewModel: PlacesViewModel
    
    // organizar por el tipo de lugar (cafeteria, emblematico, evento, etc)
    private var grouped: [(type: String, items: [Place])] {
        Dictionary(grouping: placesViewModel.places, by: { $0.type })
            .sorted { $0.key < $1.key }   // organizado alfabéticamente
            .map { ($0.key.capitalized, $0.value) }
    }
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Explora México")
                        .foregroundStyle(.black)
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                        .font(.custom("SF Pro", size: 30))
                        .padding(.horizontal, 10)
                    
                    //Filtros de botón de icono
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 20) {
                            ForEach(emojiData) { inspiration in
                                EmojiCardView(emoji: inspiration)
                            }
                        }
                        .padding(.horizontal)
                    }
                    ForEach(grouped, id: \.type) { group in
                        //Cada grupo row
                        Text(group.type.capitalized)
                            .font(.headline)
                            .padding(.horizontal, 9)
                            .foregroundColor(.black)
                            .shadow(color: .gray, radius: 1, x: 1, y: 1)
                            .font(.system(size: 20))
                        RowView(title: group.type, places: group.items)
                    }
                }
                .padding(.vertical, 16)
            }
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
                locationManager.loadPlacesAndRegisterRegions()
                    
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
            .navigationBarTitleDisplayMode(.inline)//ScrollView
            /*.navigationTitle(users.first?.city ?? "Badgely")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        
                        Text(users.first?.city ?? "Badgely")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.black)
                        
                        Image(systemName: "location")
                            .foregroundColor(.black.opacity(0.8))
                            .font(.system(size: 18))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black, lineWidth: 2)
                            .shadow(radius: 4)
                    )
                }
            }
                    )
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            */
    
            
        } //Nav Stack
        //.searchable(text: $searchText, prompt: "Search in \(users.first?.city ?? "Badgely")")
        //.searchable(text: $searchText, prompt: "Busca con Badgley")
        //.toolbarBackground(.visible, for: .navigationBar)
       /* .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("My Badges", systemImage: "person.crop.circle") {
                    navigate.toggle()
                }
            }
        }
        */
    }
}



struct FilterListView: View {
    @EnvironmentObject var placesViewModel: PlacesViewModel
    
    let typePlace: String
    let emojiData = EmojiData.examples()
    
    // Filtered places based on search text
    private var filteredPlaces: [Place] {
        if typePlace.isEmpty {
            return placesViewModel.places
        } else {
            return placesViewModel.places.filter { place in
                // primero que muestre el q lo tiene en el titulo y luego los que lo tienen en la descripcion
                
                place.name.localizedStandardContains(typePlace) //||
                //place.type.localizedStandardContains(searchText) ||
                //place.address.localizedStandardContains(searchText) ||
                //place.description.localizedStandardContains(searchText)
            }
        }
    }
    
    // Group filtered places by type
    private var grouped: [(type: String, items: [Place])] {
        Dictionary(grouping: filteredPlaces, by: { $0.type })
            .sorted { $0.key < $1.key }
            .map { ($0.key.capitalized, $0.value) }
    }
    
    var body: some View {
        Group {
            if filteredPlaces.isEmpty && !typePlace.isEmpty {
                ContentUnavailableView(
                    "No Results",
                    systemImage: "magnifyingglass",
                    description: Text("No places match '\(typePlace)'")
                )
            } else if filteredPlaces.isEmpty && typePlace.isEmpty {
                ContentUnavailableView(
                    "No Places",
                    systemImage: "map",
                    description: Text("No places available yet")
                )
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Explora México")
                            .foregroundStyle(.black)
                            .fontWeight(.bold)
                            .font(.system(size: 30))
                            .font(.custom("SF Pro", size: 30))
                            .padding(.horizontal, 10)
                        
                        // Category filter buttons
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 20) {
                                ForEach(emojiData) { inspiration in
                                    EmojiCardView(emoji: inspiration)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Grouped places by category
                        ForEach(grouped, id: \.type) { group in
                            Text(group.type.capitalized)
                                .font(.headline)
                                .padding(.horizontal, 9)
                                .foregroundColor(.black)
                                .font(.system(size: 20))
                            RowView(title: group.type, places: group.items)
                        }
                    }
                    .padding(.vertical, 16)
                }
            }
        }
    }
    
}


#Preview {
    ContentView()
        .modelContainer(for: User.self)
        .environmentObject(PlacesViewModel(places: Place.samples))
}

