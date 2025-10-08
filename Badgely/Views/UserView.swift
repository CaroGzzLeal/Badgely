//
//  UserView.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 08/10/25.
//

import SwiftUI
import SwiftData


struct UserView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var showUserSetup: Bool
    
    @State private var name = ""
    @State private var selectedCity = "Monterrey"
    @State private var selectedAvatar = "avatar1"
    
    let cities = ["Monterrey", "Guadalajara", "Mexico City"]
    let avatars = ["avatar1", "avatar2", "avatar3", "avatar4"]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Badgely")
                
                Form {
                    TextField("Your name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Picker("City", selection: $selectedCity) {
                        ForEach(cities, id: \.self) { city in
                            Text(city).tag(city)
                        }
                    }
                    
                    Picker("Avatar", selection: $selectedAvatar) {
                        ForEach(avatars, id: \.self) { avatar in
                            Text(avatar).tag(avatar)
                        }
                    }
                }
                .frame(height: 150)
                
                Button("Start Exploring") {
                    createUser()
                }
                .buttonStyle(.borderedProminent)
                .disabled(name.isEmpty)
            }
        }
        VStack {
            Text("Hello")
            
        }
    }
    
    private func createUser() {
        // Create new user with empty arrays for badges and favorites
        let user = User(name: name, city: selectedCity, avatarName: selectedAvatar)
        user.badges = []
        user.favoritePlaces = []
        
        modelContext.insert(user)
        try? modelContext.save()
        showUserSetup = false
    }
    
    
}

#Preview {
    UserView(showUserSetup: .constant(true))
        .modelContainer(for: User.self)
}
