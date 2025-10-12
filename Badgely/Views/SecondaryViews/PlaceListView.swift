//
//  PlaceListView.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 11/10/25.
//
import SwiftUI
import SwiftData

// View separate to handle places filtrados segun search o sin search.
struct PlaceListView: View {
    @EnvironmentObject var placesViewModel: PlacesViewModel
    @Environment(\.emojiData) private var emojiData
    @Environment(\.colorScheme) var colorScheme

    
    let searchText: String
   // let emojiData = EmojiData.examples()
    
    // Check if we should show places
    private var shouldShowPlaces: Bool {
        !searchText.isEmpty || selectedCategory != nil
    }
    
    @State private var selectedCategory: String? = nil // Category tracker

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
        return 5
    }
    
    // Places filtrados según search text total
    private var filteredPlaces: [Place] {
        var places = placesViewModel.places
        
        // Si hay categoria ponerle ese filtro
        if let category = selectedCategory {
            places = places.filter { $0.type == category }
        }
        
        // TLuego filtro de text search
        if !searchText.isEmpty {
            places = places.filter { place in
                place.name.localizedStandardContains(searchText) ||
                place.type.localizedStandardContains(searchText) ||
                place.address.localizedStandardContains(searchText) ||
                place.description.localizedStandardContains(searchText)
            }
            
            // Por prioridad el sort name > type > address > description
            return places.sorted { place1, place2 in
                let priority1 = searchPriority(for: place1)
                let priority2 = searchPriority(for: place2)
                
                if priority1 != priority2 {
                    return priority1 < priority2 // menor num mayor prob
                } else {
                    // Same priority, sort alphabetically by name
                    return place1.name.localizedCaseInsensitiveCompare(place2.name) == .orderedAscending
                }
            }
        }
        
        return places
    }
    
    // Places filtrados por type
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
                            .foregroundStyle(Color(colorScheme == .dark ? .white : .black))
                            .fontWeight(.bold)
                            .font(.system(size: 30))
                            .font(.custom("SF Pro", size: 30))
                            .padding(.horizontal, 10)
                        
                        // Category filter buttons emoji
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 20) {
                                ForEach(emojiData) { inspiration in
                                    EmojiCardView(
                                        emoji: inspiration,
                                        isSelected: selectedCategory == inspiration.name,
                                        isAnySelected: selectedCategory != nil,
                                        action: {
                                            // Category toggle time
                                            if selectedCategory == inspiration.name {
                                                selectedCategory = nil // deselecciona si ya selecteado
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
                // Vista para cuando no hay search (ContentView)
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
                                .foregroundStyle(Color(colorScheme == .dark ? .white : .black))
                                .fontWeight(.bold)
                                .font(.system(size: 30))
                                .font(.custom("SF Pro", size: 30))
                                .padding(.horizontal, 10)
                            
                            
                            // Category filter buttons emoji
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 20) {
                                    ForEach(emojiData) { inspiration in
                                        EmojiCardView(
                                            emoji: inspiration,
                                            isSelected: selectedCategory == inspiration.name,
                                            isAnySelected: selectedCategory != nil,
                                            action: {
                                                // Category toggle time
                                                if selectedCategory == inspiration.name {
                                                    selectedCategory = nil // deselecciona si ya selecteado
                                                } else {
                                                    selectedCategory = inspiration.name
                                                }
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            // Grouped places x category
                            ForEach(grouped, id: \.type) { group in
                                Text(group.type)
                                    .font(.headline)
                                    .padding(.horizontal, 9)
                                    .foregroundColor(Color(colorScheme == .dark ? .white : .black))
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


