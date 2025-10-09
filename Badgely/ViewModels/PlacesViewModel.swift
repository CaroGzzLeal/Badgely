//
//  PlacesViewModel.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 09/10/25.
//
import SwiftUI

@MainActor
final class PlacesViewModel: ObservableObject {
    @Published var places: [Place] = []

    init() {
        loadPlaces()
    }
    
    private func loadPlaces() {
        places = Bundle.main.decode("places2.json")
    }
}
