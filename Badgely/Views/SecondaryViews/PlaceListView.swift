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
                    return priority1 < priority2
                } else {
                    return place1.name.localizedCaseInsensitiveCompare(place2.name) == .orderedAscending
                }
            }
        }
        
        return places
    }
    
    // Places filtrados por type
    private var grouped: [(type: String, items: [Place])] {
        Dictionary(grouping: filteredPlaces, by: \.type)
            .map { ($0.key.capitalized, $0.value) }
            .sorted {
                if $0.type.lowercased() == "partido" { return true } //primero partido
                if $1.type.lowercased() == "partido" { return false }
                return $0.type.localizedCaseInsensitiveCompare($1.type) == .orderedAscending
            }
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
                                "No hay resultados sobre '\(searchText)'",
                                systemImage: "magnifyingglass",
                                description: Text("Revisa la ortografía o intenta buscar algo distinto.")
                            )
                        } else {
                            
                            ColumnView(title: "Resultados", places: filteredPlaces)
                                .padding(.top, 8)
                        }
                    }
                    //.padding(.vertical, 16)
                }
                
            } else {
                // Vista para cuando no hay search (ContentView)
                if placesViewModel.places.isEmpty {
                    ContentUnavailableView(
                        "No Hay Lugares",
                        systemImage: "map",
                        description: Text("No hay lugares disponibles por el momento")
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
                                if group.type == "Cafeteria" {
                                    Text("Cafetería")
                                        .font(.headline)
                                        .padding(.horizontal, 9)
                                        .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                                        .font(.system(size: 20))
                                } else if group.type == "Emblematico" {
                                    Text("Emblemático")
                                        .font(.headline)
                                        .padding(.horizontal, 9)
                                        .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                                        .font(.system(size: 20))
                                } else if group.type == "Area_Verde" {
                                    Text("Áreas Verdes")
                                        .font(.headline)
                                        .padding(.horizontal, 9)
                                        .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                                        .font(.system(size: 20))
                                } else if group.type == "Vida_Nocturna" {
                                    Text("Vida Nocturna")
                                        .font(.headline)
                                        .padding(.horizontal, 9)
                                        .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                                        .font(.system(size: 20))
                                }
                                else {
                                    Text(group.type)
                                        .font(.headline)
                                        .padding(.horizontal, 9)
                                        .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                                        .font(.system(size: 20))
                                }
                                RowView(places: group.items)
                            }
                        }
                        //.padding(.vertical, 16)
                    }
                }
            }
        }
    }
}


// View separate to handle places filtrados sin search.
struct ContentPlaceListView: View {
    @EnvironmentObject var placesViewModel: PlacesViewModel
    @Environment(\.colorScheme) var colorScheme

    // Places filtrados según search text total
    private var filteredPlaces: [Place] {
        var places = placesViewModel.places
        return places
    }
    
    // Places filtrados por type
    private var grouped: [(type: String, items: [Place])] {
        Dictionary(grouping: filteredPlaces, by: \.type)
            .map { ($0.key.capitalized, $0.value) }
            .sorted {
                if $0.type.lowercased() == "partido" { return true } //primero partido
                if $1.type.lowercased() == "partido" { return false }
                return $0.type.localizedCaseInsensitiveCompare($1.type) == .orderedAscending
            }
    }

    var body: some View {
                //Text("Explora México")
                //    .foregroundStyle(Color(colorScheme == .dark ? .white : .black))
                //    .fontWeight(.bold)
                //    .font(.system(size: 30))
                //    .font(.custom("SF Pro", size: 30))
                //    .padding(.horizontal, 10)
                
                // Grouped places x category
                ForEach(grouped, id: \.type) { group in
                    if group.type == "Cafeteria" {
                        Text("Cafetería")
                            .font(.headline)
                            .padding(.horizontal, 9)
                            .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                            .font(.system(size: 20))
                            
                    } else if group.type == "Emblematico" {
                        Text("Emblemático")
                            .font(.headline)
                            .padding(.horizontal, 9)
                            .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                            .font(.system(size: 20))
                    } else if group.type == "Area_Verde" {
                        Text("Área Verde")
                            .font(.headline)
                            .padding(.horizontal, 9)
                            .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                            .font(.system(size: 20))
                    } else if group.type == "Vida_Nocturna" {
                        Text("Vida Nocturna")
                            .font(.headline)
                            .padding(.horizontal, 9)
                            .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                            .font(.system(size: 20))
                    }
                    else {
                        Text(group.type)
                            .font(.headline)
                            .padding(.horizontal, 9)
                            .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                            .font(.system(size: 20))
                    }
                    RowView(places: group.items)
                }
            
            
         //scrollview
                
            
        
    }
}
