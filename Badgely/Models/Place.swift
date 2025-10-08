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
    let lat: String
    let long: String
    let description: String
    
    var displayName: String {
        "\(name)"
    }
    
    var image: String {
        "\(type)\(id)"
    }
}


