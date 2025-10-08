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
    
    var displayName: String {
        "\(name)"
    }
    
    var image: String {
        "\(type)\(id)"
    }
}

