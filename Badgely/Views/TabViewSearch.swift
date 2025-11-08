//
//  TabViewSearch.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 10/10/25.
//

import SwiftUI
import SwiftData

struct TabViewSearch: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]

    
    @EnvironmentObject var placesViewModel: PlacesViewModel
    
    private var currentUser: User? { users.first }
    
    
    var body: some View {
        TabView {
            Tab("Inicio", systemImage: "house") {
                ContentView()
            }
            
            Tab("Favortios", systemImage: "heart") {
                if let user = currentUser {
                    FavoritesView(user: user)
                } else {
                    Text("No user found")
                        .foregroundStyle(.secondary)
                }
                //BadgesView(user:user)
                
                //square.and.arrow.up.badge.clockFavoritesView()
            }
            
            Tab("Álbum", systemImage: "photo.on.rectangle.angled") {
                if let user = currentUser {
                    Log2(user: user)
                } else {
                    Text("No user found")
                        .foregroundStyle(.secondary)
                }
            }
            
            Tab("Insignias", systemImage: "person") {
                if let user = currentUser {
                    BadgesView(user: user)
                } else {
                    Text("No se encontró un usuario")
                        .foregroundStyle(.secondary)
                }
            }
            
            Tab (role: .search) {
                SearchView()
                
            }
            
            
        }
    }
}


#Preview {
    TabViewSearch()
        .modelContainer(for: User.self)
        .environmentObject(PlacesViewModel(places: Place.samples))
}
