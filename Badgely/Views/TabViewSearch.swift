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
            Tab("Home Page", systemImage: "house") {
                ContentView()
            }
            
            Tab("Favorites", systemImage: "heart") {
                if let user = currentUser {
                    FavoritesView(user: user)
                } else {
                    Text("No user found")
                        .foregroundStyle(.secondary)
                }
                //BadgesView(user:user)
                
                //square.and.arrow.up.badge.clockFavoritesView()
            }
            
            Tab("Badges", systemImage: "person") {
                if let user = currentUser {
                    BadgesView(user: user)
                } else {
                    Text("No user found")
                        .foregroundStyle(.secondary)
                }
            }
            
            Tab("Logs", systemImage: "photo.on.rectangle.angled") {
                ContentView()
            }
            
            Tab (role: .search) {
                ContentView()
            }
            
            
        }
    }
}


#Preview {
    TabViewSearch()
        .modelContainer(for: User.self)
        .environmentObject(PlacesViewModel(places: Place.samples))
}
