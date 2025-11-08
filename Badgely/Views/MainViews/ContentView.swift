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
    @EnvironmentObject var placesViewModel: PlacesViewModel
    
    @State private var navigate = false
    @State private var searchText = ""
    @State private var showLocationPicker = false
    
    @EnvironmentObject private var locationManager: LocationManager
    
    @Environment(\.colorScheme) var colorScheme
    
    //let emojiData = EmojiData.examples()
    
    var body: some View {
        NavigationStack {
            //PlacesView()
            PlaceListView(searchText: searchText)
                //Everything needed for changing the location CDMX, MTY O GDL
                .sheet(isPresented: $showLocationPicker) {
                    if let user = users.first {
                        LocationPickerView(user: user, placesViewModel: placesViewModel)
                    }
                }
                .onAppear {
                    // Cargar lugares de la ciudad del user
                    if let city = users.first?.city {
                        placesViewModel.loadPlaces(for: city)
                    }
                    locationManager.loadPlacesAndRegisterRegions()
                    print(users[0].badges)
                    print(users[0].specialBadges)
                    print(users[0].responsibleBadges)
                }
                .onChange(of: users.first?.city) { oldValue, newValue in
                    // reload si city cambia
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
                // TO HERE, COMPONENTE PARA EL CHANGE DE CITY
        }
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: User.self)
        .environmentObject(PlacesViewModel(places: Place.samples))
}





