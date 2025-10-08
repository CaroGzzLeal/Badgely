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
    var badges: [String] = []
    var favoritePlaces: [String] = []
    

    init(name: String, city: String, avatarName: String ) {
        self.name = name
        self.city = city
        self.avatarName = avatarName
    }
    
}


