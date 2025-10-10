//
//  ContentView.swift
//  Badgely
//
//  Created by Carolina Nicole Gonzalez Leal on 06/10/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    //@Query(sort: \User.name) private var users: [User]
    
    @State private var navigate = false
    @State private var searchText = ""
    
    let emojiData = EmojiData.examples()
    
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
            } //ScrollView
            .navigationTitle(users.first?.city ?? "Badgely")
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
            .navigationBarTitleDisplayMode(.inline)
            
    
            
        } //Nav Stack
        .searchable(text: $searchText, prompt: "Search in \(users.first?.city ?? "Badgely")")
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


#Preview {
    ContentView()
        .modelContainer(for: User.self)
        .environmentObject(PlacesViewModel(places: Place.samples))
}

