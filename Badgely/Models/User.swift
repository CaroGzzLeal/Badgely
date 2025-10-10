//
//  User.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 07/10/25.
//
import SwiftUI
import SwiftData

//diccionario todas las categorias,

// solo para el user y sus badges
@Model
class User {
    var name: String
    var city: String
    var avatarName: String
    var badges: [Badge] = []
    var favoritePlaces: [String] = []
    

    init(name: String, city: String, avatarnName: String ) {
        self.name = name
        self.city = city
        self.avatarName = avatarnName
    }
    
    
}


@Model
class Badge {
    var name: String
    var city: String
    var category: String
    var imageName: String
    var date: Date
    var placeId: String?
    var isAchievement: Bool = false
    
    init(name: String, city: String, category: String, imageName: String, date: Date, placeId: String? = nil, isAchievement: Bool = false) {
        self.name = name
        self.city = city
        self.category = category
        self.imageName = imageName
        self.date = date
        self.placeId = placeId
        self.isAchievement = isAchievement
    }
}
