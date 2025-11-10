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
    private let globalEmojiData = EmojiData.examples()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([User.self, Photo.self])
        let config = ModelConfiguration("group.caroworks.Badgely")
        return try! ModelContainer(for: schema, configurations: [config])
    }()
    
    var body: some Scene {
        WindowGroup {
            NewUserView()
                .environmentObject(placesViewModel)
                .environmentObject(locationManager)
                .environment(\.emojiData, globalEmojiData)
        }
        .modelContainer(sharedModelContainer)
        
    }
}
