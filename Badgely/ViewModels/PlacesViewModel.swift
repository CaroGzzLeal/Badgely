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
        loadPlaces(for: "Monterrey") //Monterrey default regio moment
    }
    
    // Convenience init for previews/tests
    init(places: [Place]) {
        self.places = places
    }
    
    func loadPlaces(for city: String) {
        let fileName = jsonFileName(for: city)
        
        // Try to load city-specific JSON, fallback to default if not found
        if Bundle.main.url(forResource: fileName, withExtension: nil) != nil {
            places = Bundle.main.decode(fileName)
        } else {
            // Fallback to Monterrey (places2.json) if city-specific file doesn't exist
            print("⚠️ No JSON file found for \(city), using default Monterrey places")
            places = Bundle.main.decode("places2.json")
        }
    }
    
    private func jsonFileName(for city: String) -> String {
        switch city {
        case "Monterrey":
            return "places2.json"
        case "Guadalajara":
            return "places_guadalajara.json"
        case "Mexico City":
            return "places_mexicocity.json"
        default:
            return "places2.json"
        }
    }
    
    /*private func loadPlaces() {
        places = Bundle.main.decode("places2.json")
    }*/
}
