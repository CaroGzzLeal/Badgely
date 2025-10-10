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
    @Query private var users: [User]
    
    @EnvironmentObject var placesViewModel: PlacesViewModel
    
    @State private var name = ""
    @State private var selectedCity = "Monterrey"
    @State private var selectedAvatar = "avatar1"
    
    let cities = ["Monterrey", "Guadalajara", "Mexico City"]
    let avatars = ["avatar1", "avatar2", "avatar3", "avatar4"]
    
    var body: some View {
        Group {
            if users.isEmpty {
                // Onboarding
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
                        }

                        Button("Start Exploring") {
                            createUser()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(name.isEmpty)
                    }
                    .padding(.top, 8)
                }
            } else {
                //Directo a ContentView si user ya existe
                //ContentView()
                TabViewSearch()
            }
        }
        .animation(.default, value: users.count) // smooth switch when user gets created
    }
    
    private func createUser() {
        let user = User(name: name, city: selectedCity)
        modelContext.insert(user)
        do {
            try modelContext.save()
            // No manual navigation needed — the @Query will update and show ContentView 
            print("User created: \(user.name) in \(user.city)")
        } catch {
            print("Error creating user: \(error.localizedDescription)")
        }
    }
}

#Preview {
    UserView()
        .modelContainer(for: User.self)
}
