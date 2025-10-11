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
    @Environment(\.colorScheme) var colorScheme
    
    @State private var name = ""
    @State private var selectedCity = "Monterrey"
    @State private var selectedAvatar = "avatar1"
    
    let cities = ["Monterrey", "Guadalajara", "Mexico City"]
    let avatars = ["avatar1", "avatar2", "avatar3", "avatar4"]
    
    @State private var isLogin = true
    
    var body: some View {
        Group {
            if users.isEmpty {
                // Onboarding
                NavigationStack {
                    
                    VStack {
                        
                        Image("icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130, height: 130)
                        
                        Text("¡Bienvenido Explorador!")
                            //.foregroundStyle(.black)
                            .fontWeight(.bold)
                            .font(.system(size: 28))
                            .font(.custom("SF Pro", size: 28))
                            .padding(.horizontal, 10)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                            //.background(colorScheme == .dark ? .black : .white)
                        /*
                        HStack {
                            Button("Iniciar sesión") { isLogin = true }
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .background(isLogin ? Color(red: 30/255, green: 94/255, blue: 54/255) : Color(.systemGray6))
                                .foregroundColor(isLogin ? .white : .black)
                                .font(.system(size: 20))
                                .font(.custom("SF Pro", size: 20))

                            Button("Registrarse") { isLogin = false }
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .background(isLogin ? Color(.systemGray6) : Color(red: 30/255, green: 94/255, blue: 54/255))
                                .foregroundColor(isLogin ? .black : .white)
                                .font(.system(size: 20))
                                .font(.custom("SF Pro", size: 20))
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 35))
                        .shadow(radius: 2)
                        .padding(10)
                        */
                        
                        Form {
                            Section {
                                TextField("Ingresa tu nombre", text: $name)
                                    .textFieldStyle(.roundedBorder)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color(colorScheme == .dark ? .white : .black))
                                    }
                                    .font(.custom("SF Pro", size: 25))
                                    .lineLimit(1)
                                
                                VStack{
                                    Picker("Ciudad", selection: $selectedCity) {
                                        ForEach(cities, id: \.self) { city in
                                            Text(city).tag(city)
                                                .foregroundColor(Color(red: 211/255, green: 211/255, blue: 211/255))
                                                .font(.custom("SF Pro", size: 25))
                                        }
                                    }
                                    
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 8)
                                    .foregroundColor(Color(red: 211/255, green: 211/255, blue: 211/255))
                                    .font(.custom("SF Pro", size: 25))
                                }
                                //.textFieldStyle(.roundedBorder)
                                //.clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(colorScheme == .dark ? .white : .black))
                                }
                                .font(.custom("SF Pro", size: 25))
                                .padding(.vertical, 10)
                                //.padding(.horizontal, 16)
                                .foregroundColor(Color.primary)
                            } //Section
                            .listRowBackground(Color.clear)
                        } //Form
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .listRowSeparator(.hidden)
                        .listSectionSeparator(.hidden)

                        /*
                        Button("Empezar a Explorar") {
                            createUser()
                            
                        }
                        // .buttonStyle(.borderedProminent)
                        .disabled(name.isEmpty)
                        .buttonStyle(.bordered)
                        //.buttonBorderShape(.roundedRectangle(radius: 10))
                        .foregroundColor(.white)
                        .font(.custom("SF Pro", size:20))
                        .background(Color(red: 30/255, green: 94/255, blue: 54/255))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        */
                        
                        Button {
                            createUser()
                        } 
                        label: {
                            Text("Empezar a Explorar")
                                .padding(.vertical, 10)
                                .padding(.horizontal, 16)
                                .font(.custom("SF Pro", size:20))
                                .foregroundColor(.white)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(red: 30/255, green: 94/255, blue: 54/255))
                        )
                        .disabled(name.isEmpty)
                    } //VStack
                    //.padding(.top, 8)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } //NavigationStack
            } //if
            else {
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
