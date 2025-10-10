//
//  Untitled.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 07/10/25.
//

struct Place: Codable, Identifiable {

    let id: Int
    let name: String
    let type: String
    let address: String
    let latitude: Double
    let longitude: Double
    let description: String
    let badge: String
    let specialBadge: String
    
    var displayName: String {
        "\(name)"
    }
    
    var image: String {
        "\(type)\(id)"
    }
}


extension Place {
    static let sample1 = Place(
        id: 1,
        name: "Café Azul",
        type: "cafe",
        address: "Av. Siempre Viva 123, Monterrey",
        latitude: 25.6866,
        longitude: -100.3161,
        description: "Great coffee and pastries.",
        badge: "Open late",
        specialBadge: ""
    )
    
    static let sample2 = Place(
        id: 2,
        name: "Parque Fundidora",
        type: "park",
        address: "Av. Fundidora S/N, Monterrey",
        latitude: 25.6778,
        longitude: -100.2856,
        description: "Iconic urban park with museums and lakes.",
        badge: "Family friendly",
        specialBadge: "Must see"
    )
    
    static let samples: [Place] = [.sample1, .sample2]
}
