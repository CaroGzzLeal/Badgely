//
//  ContentView.swift
//  Badgely
//
//  Created by Carolina Nicole Gonzalez Leal on 06/10/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    let places: [Place] = Bundle.main.decode("places.json")
    
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    
    private var grouped: [(type: String, items: [Place])] {
        Dictionary(grouping: places, by: { $0.type })
            .sorted { $0.key < $1.key }   // alphabetical sections
            .map { ($0.key.capitalized, $0.value) }
    }
    
    var body: some View {
        NavigationStack {
            //Text(String(astronauts.count))
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ForEach(grouped, id: \.type) { group in
                        RowView(title: group.type, places: group.items)
                    }
                }
                .padding(.vertical, 16)
                /*LazyVGrid(columns: columns) {
                    ForEach (places, id: \.id) { place in
                        NavigationLink(destination: PlaceDetailView(place: place)) {
                            VStack {
                                Image(place.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)

                                VStack {
                                    Text(place.displayName)
                                        .font(.headline)
                                    Text(place.address)
                                        .font(.caption)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    
                }*/
                
            }
        }
        
    }
}

struct PlaceDetailView: View {
    var place: Place
    var body: some View {
        VStack {
            Text(place.displayName)
            Image(place.image)
        }
    }
}

struct RowView: View {
    let title: String
    let places: [Place]
    let rows = [
        GridItem(.adaptive(minimum: 150))
    ]
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows) {
                    ForEach(places) { place in
                        NavigationLink(destination: PlaceDetailView(place: place)) {
                            Image(place.image)
                                .resizable()
                                .frame(width: 100, height: 100)
                        }
                    }
                }
                
            }
        }
    }
}

#Preview {
    ContentView()
}
