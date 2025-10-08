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
    
    

    init(name: String, city: String, avatarnName: String ) {
        self.name = name
        self.city = city
        self.avatarName = avatarnName
    }
    
}

class Badge {
    var name: String
    var city: String
    var category: String
    var imageName: String
    var date: Date
    

    init(name: String, city: String, category: String, imageName: String, date: Date ) {
        self.name = name
        self.city = city
        self.category = category
        self.imageName = imageName
        self.date = date
    }
    
}

