//
//  Badge.swift
//  Badgely
//
//  Created by Carolina Nicole Gonzalez Leal on 09/10/25.
//

import Foundation
import SwiftData

@Model
class Photo: Identifiable {
    var name: String
    @Attribute(.externalStorage) var photo: Data
    var date: Date = Date()
    var badgeName: String?
    var place: String
    var city: String
    
    init(name: String, photo: Data, badgeName: String, place: String, city: String) {
        self.name = name
        self.photo = photo
        self.badgeName = badgeName
        self.place = place
        self.city = city
    }
}
