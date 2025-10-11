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
                //Everything needed for changing the location CDMX, MTY O GDL
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
                // TO HERE, COPY IT WHERE YOU NEED TO CHANGE THE LOCATION
        }
        .searchable(text: $searchText, prompt: "Search in \(users.first?.city ?? "Badgely")")
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

// Separate view to handle filtered places based on search
struct PlaceListView: View {
    @EnvironmentObject var placesViewModel: PlacesViewModel
    
    let searchText: String
    let emojiData = EmojiData.examples()
    
    // Check if we should show places
    private var shouldShowPlaces: Bool {
        !searchText.isEmpty || selectedCategory != nil
    }
    
    @State private var selectedCategory: String? = nil // Track selected category

    // Muestra en orden de mayor importancia (nomnre, type, descr
    private func searchPriority(for place: Place) -> Int {
        if place.name.localizedStandardContains(searchText) {
            return 1
        } else if place.type.localizedStandardContains(searchText) {
            return 2
        } else if place.address.localizedStandardContains(searchText) {
            return 3
        } else if place.description.localizedStandardContains(searchText) {
            return 4
        }
        return 5 // Shouldn't reach here
    }
    
    // Filtered places based on search text
    private var filteredPlaces: [Place] {
        var places = placesViewModel.places
        
        // First apply category filter if selected
        if let category = selectedCategory {
            places = places.filter { $0.type == category }
        }
        
        // Then apply search filter if searching
        if !searchText.isEmpty {
            places = places.filter { place in
                place.name.localizedStandardContains(searchText) ||
                place.type.localizedStandardContains(searchText) ||
                place.address.localizedStandardContains(searchText) ||
                place.description.localizedStandardContains(searchText)
            }
            
            // Sort by priority: name > type > address > description
            return places.sorted { place1, place2 in
                let priority1 = searchPriority(for: place1)
                let priority2 = searchPriority(for: place2)
                
                if priority1 != priority2 {
                    return priority1 < priority2 // Lower number = higher priority
                } else {
                    // Same priority, sort alphabetically by name
                    return place1.name.localizedCaseInsensitiveCompare(place2.name) == .orderedAscending
                }
            }
        }
        
        return places
    }
    
    // Group filtered places by type
    private var grouped: [(type: String, items: [Place])] {
        Dictionary(grouping: filteredPlaces, by: { $0.type })
            .sorted { $0.key < $1.key }
            .map { ($0.key.capitalized, $0.value) }
    }
    
    var body: some View {
        Group {
            if !searchText.isEmpty {
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
                                    EmojiCardView(
                                        emoji: inspiration,
                                        isSelected: selectedCategory == inspiration.name,
                                        isAnySelected: selectedCategory != nil,
                                        action: {
                                            // Toggle category selection
                                            if selectedCategory == inspiration.name {
                                                selectedCategory = nil // Deselect if already selected
                                            } else {
                                                selectedCategory = inspiration.name
                                            }
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        
                        if filteredPlaces.isEmpty {
                            
                            ContentUnavailableView(
                                "No Results",
                                systemImage: "magnifyingglass",
                                description: Text("No places match '\(searchText)'")
                            )
                        } else {
                            
                            ColumnView(title: "Results", places: filteredPlaces)
                                .padding(.top, 8)
                        }
                    }
                    .padding(.vertical, 16)
                }
                
            } else {
                // Not searching → your original home with RowView sections
                if placesViewModel.places.isEmpty {
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
                                        EmojiCardView(
                                            emoji: inspiration,
                                            isSelected: selectedCategory == inspiration.name,
                                            isAnySelected: selectedCategory != nil,
                                            action: {
                                                // Toggle category selection
                                                if selectedCategory == inspiration.name {
                                                    selectedCategory = nil // Deselect if already selected
                                                } else {
                                                    selectedCategory = inspiration.name
                                                }
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            // Grouped places by category
                            ForEach(grouped, id: \.type) { group in
                                Text(group.type)
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

