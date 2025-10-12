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


#Preview {
    SearchView()
        .modelContainer(for: User.self)
        .environmentObject(PlacesViewModel(places: Place.samples))
}

