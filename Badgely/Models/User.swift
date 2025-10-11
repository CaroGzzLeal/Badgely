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
    var avatar: String
    var city: String
    var badges: [String] = []
    var specialBadges: [String] = []
    var favorites: [Int] = []

    init(
         name: String,
         avatar: String,
         city: String,
         badges: [String] = [],
         specialBadges: [String] = [],
         favorites: [Int] = []
     ) {
         self.name = name
         self.avatar = avatar
         self.city = city
         self.badges = badges
         self.specialBadges = specialBadges
         self.favorites = favorites
     }
}
