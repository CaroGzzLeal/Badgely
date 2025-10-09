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
        }
        .modelContainer(for: User.self)
    }
}
