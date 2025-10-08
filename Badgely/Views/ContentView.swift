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
    
    let emojiData = EmojiData.examples()
    let places: [Place] = Bundle.main.decode("places2.json")
    
    // organizar por el tipo de lugar (cafeteria, emblematico, evento, etc)
    private var grouped: [(type: String, items: [Place])] {
        Dictionary(grouping: places, by: { $0.type })
            .sorted { $0.key < $1.key }   // organizado alfabéticamente
            .map { ($0.key.capitalized, $0.value) }
    }
    
    var body: some View {
        NavigationStack {
            
            NavigationLink(destination: {NearYouView()}, label: {
                Text("Places near you")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            })
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    
                    //Filtros de botón de icono
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 20) {
                            ForEach(emojiData) { inspiration in
                                EmojiCardView(emoji: inspiration)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    //For por cada grupo
                    ForEach(grouped, id: \.type) { group in
                        //Cada grupo row
                        Text(group.type.capitalized)
                            .font(.headline)
                            .padding(.horizontal, 7)
                        RowView(title: group.type, places: group.items)
                    }
                }
                .padding(.vertical, 16)
                .onAppear {
                    locationManager.loadPlacesAndRegisterRegions()
                }
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
