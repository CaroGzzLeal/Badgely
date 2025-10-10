//
//  SearchView.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 10/10/25.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    @EnvironmentObject var placesViewModel: PlacesViewModel
    
    @State private var navigate = false
    @State private var searchText = ""
    @State private var showLocationPicker = false
    
    var body: some View {
        NavigationStack {
            PlaceListView(searchText: searchText)
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
        //.searchable(text: $searchText, prompt: "Busca con Badgely")
        .searchable(text: $searchText, prompt: "Search in \(users.first?.city ?? "Badgely")")
        .toolbarBackground(.visible, for: .navigationBar)
    }
}



// Separate view to handle filtered places based on search
struct PlaceListView: View {
    @EnvironmentObject var placesViewModel: PlacesViewModel
    
    let searchText: String
    let emojiData = EmojiData.examples()
    
    // Filtered places based on search text
    private var filteredPlaces: [Place] {
        if searchText.isEmpty {
            return placesViewModel.places
        } else {
            return placesViewModel.places.filter { place in
                // primero que muestre el q lo tiene en el titulo y luego los que lo tienen en la descripcion
                
                place.name.localizedStandardContains(searchText) //||
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
            if filteredPlaces.isEmpty && !searchText.isEmpty {
                ContentUnavailableView(
                    "No Results",
                    systemImage: "magnifyingglass",
                    description: Text("No places match '\(searchText)'")
                )
            } else if filteredPlaces.isEmpty && searchText.isEmpty {
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
    SearchView()
        .modelContainer(for: User.self)
        .environmentObject(PlacesViewModel(places: Place.samples))
}

