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
    @State private var showUserSetup = true
    
    /*var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()*/
    
    var body: some Scene {
        WindowGroup {
            if showUserSetup {
                UserView(showUserSetup: $showUserSetup)
            } else {
                ContentView()
            }
        }
        .modelContainer(for: User.self)
    }
}
