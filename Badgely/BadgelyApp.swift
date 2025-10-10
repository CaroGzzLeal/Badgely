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
    /*let container: ModelContainer = {
        do {
            return try ModelContainer(for: User.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error.localizedDescription)")
        }
    }()*/
    
    var body: some Scene {
        WindowGroup {
            UserView()
                .environmentObject(placesViewModel)
                .environmentObject(placesViewModel)
        }
        .modelContainer(for: [User.self, Photo.self])
        
    }
}
