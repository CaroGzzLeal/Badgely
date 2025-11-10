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
    
    // init para tests previos
    init(places: [Place]) {
        self.places = places
    }
    
    func loadPlaces(for city: String) {
        let fileName = jsonFileName(for: city)
        
        // load JSON de ciudadTry to load city-specific JSON, fallback to default if not found
        if Bundle.main.url(forResource: fileName, withExtension: nil) != nil {
            places = Bundle.main.decode(fileName)
        } else {
            // Fallback es mty si no encuentra json.
            print("No JSON de \(city), default MTY")
            places = Bundle.main.decode("places2.json")
        }
    }
    
    private func jsonFileName(for city: String) -> String {
        switch city {
        case "Monterrey":
            return "places2.json"
        case "Guadalajara":
            return "places_guadalajara.json"
        case "Ciudad de México":
            return "places_mexicocity.json"
        default:
            return "places2.json"
        }
    }
    
    /*private func loadPlaces() {
        places = Bundle.main.decode("places2.json")
    }*/
}
