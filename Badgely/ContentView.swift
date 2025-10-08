//
//  ContentView.swift
//  Badgely
//
//  Created by Carolina Nicole Gonzalez Leal on 06/10/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var navigate = false
    @State private var searchText = ""
    
    let emojiData = EmojiData.examples()
    
    let places: [Place] = Bundle.main.decode("places2.json")
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    // organizar por el type
    private var grouped: [(type: String, items: [Place])] {
        Dictionary(grouping: places, by: { $0.type })
            .sorted { $0.key < $1.key }   // organizado alfabéticamente
            .map { ($0.key.capitalized, $0.value) }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                LazyVStack(alignment: .leading) {
                    ScrollView(.horizontal) {
                        VStack{
                            LazyHStack(spacing: 20) {
                                ForEach(emojiData) { inspiration in
                                    EmojiCardView(emoji: inspiration)
                                }
                            }
                        }
                    }
                }
                
                
                VStack(alignment: .leading, spacing: 24) {
                    ForEach(grouped, id: \.type) { group in
                        Text(group.type.capitalized)
                            .font(.headline)
                            .padding(.horizontal, 7)
                        RowView(title: group.type, places: group.items)
                    }
                }
                .padding(.vertical, 16)
            } //ScrollView
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("My Badges", systemImage: "person.crop.circle") {
                        navigate.toggle()
                    }
                }
            }
            .sheet(isPresented: $navigate) {
               BadgesView()
                    //.presentationDetents([.medium,.large])
            }
            .navigationTitle("Monterrey")
            .navigationBarTitleDisplayMode(.inline)
        } //Nav Stack
        .searchable(text: $searchText, prompt: "Busca con Badgley")
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


struct BadgesView: View {
    var body: some View {
        VStack {
            Text("My Badges")
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
