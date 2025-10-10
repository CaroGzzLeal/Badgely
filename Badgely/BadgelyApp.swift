//
//  BadgelyApp.swift
//  Badgely
//
//  Created by Carolina Nicole Gonzalez Leal on 06/10/25.
//

import SwiftUI
import SwiftData

@main
struct BadgelyApp: App {
    @StateObject private var placesViewModel = PlacesViewModel()
    @StateObject private var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            UserView()
                .environmentObject(placesViewModel)
                .environmentObject(locationManager)
        }
        .modelContainer(for: [User.self, Photo.self])
        
    }
}
