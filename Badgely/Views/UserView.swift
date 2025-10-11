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
    @State private var selectedAvatar = "profile1"
    
    let cities = ["Monterrey", "Guadalajara", "Mexico City"]
    let avatars = ["profile1", "profile2", "profile3", "profile4"]
    //let avatars = ["avatar1", "avatar2", "avatar3", "avatar4"]
    
    var body: some View {
        Group {
            if users.isEmpty {
                // Onboarding
                VStack{
                        VStack {
                            Image("icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                        }
                    Form {
                            Section {
                                VStack(spacing:35) {
                                    Text("¡Bienvenido a la comunidad Badgely!")
                                        .fontWeight(.bold)
                                        .font(.title).bold()
                                        .font(.system(size: 32))
                                        .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .listRowSeparator(.hidden)
                                    
                                    VStack(spacing:10) {
                                        Text("Ingresa tu nombre:")
                                            .foregroundStyle(Color(colorScheme == .dark ? .white : .black))
                                            .fontWeight(.bold)
                                            .font(.system(size: 20))
                                            .listRowSeparator(.hidden)
                                        
                                        TextField("", text: $name)
                                            .textFieldStyle(.roundedBorder)
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color(colorScheme == .dark ? .white : .black))
                                            }
                                            .font(.custom("SF Pro", size: 25))
                                            .lineLimit(1)
                                    } .listRowSeparator(.hidden)
                                    
                                    /*VStack(spacing:10){
                                        Text("País de tu proximo destino:")
                                            .foregroundStyle(Color(colorScheme == .dark ? .white : .black))
                                            .fontWeight(.bold)
                                            .font(.system(size: 18))
                                            .listRowSeparator(.hidden)
                                        
                                        VStack {
                                            Picker("", selection: $selectedCity) {
                                                ForEach(cities, id: \.self) { city in
                                                    Text(city).tag(city)
                                                }
                                            }
                                            .padding(.vertical, 10)
                                            .padding(.horizontal, 8)
                                            .font(.custom("SF Pro", size: 25))
                                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                            .background(
                                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                    .fill(colorScheme == .dark ? Color.black : Color.white)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                    .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 1)
                                            )

                                        }

                                    }*/
                                    
                                    VStack(spacing:10) {
                                        Text("Ciudad de tu proximo destino:")
                                            .foregroundStyle(Color(colorScheme == .dark ? .white : .black))
                                            .fontWeight(.bold)
                                            .font(.system(size: 20))
                                            .listRowSeparator(.hidden)
                                        
                                        VStack {
                                            Picker("", selection: $selectedCity) {
                                                ForEach(cities, id: \.self) { city in
                                                    Text(city).tag(city)
                                                }
                                            }
                                            .padding(.vertical, 10)
                                            .padding(.horizontal, 8)
                                            .font(.custom("SF Pro", size: 25))
                                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                            .background(
                                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                    .fill(colorScheme == .dark ? Color.black : Color.white)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                    .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 1)
                                            )

                                        }
                                    }  .listRowSeparator(.hidden)
                                    
                                    VStack(spacing:10) {
                                        Text("Selecciona tu avatar:")
                                            .foregroundStyle(Color(colorScheme == .dark ? .white : .black))
                                            .fontWeight(.bold)
                                            .font(.system(size: 20))
                                            .listRowSeparator(.hidden)
                                        
                                        Button(action: {
                                            if let idx = avatars.firstIndex(of: selectedAvatar) {
                                                let next = (idx + 1) % avatars.count
                                                selectedAvatar = avatars[next]
                                            } else {
                                                selectedAvatar = avatars.first ?? selectedAvatar
                                            }
                                        }) {
                                            VStack(spacing: 8) {
                                                Image(selectedAvatar)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 120, height: 120)
                                                    .clipShape(Circle())
                                                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                                            }
                                        }
                                        .buttonStyle(.plain)
                                        
                                    }
                                }
                                //tiene q ir aqui
                            }
                            .listRowBackground(Color.clear)
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .listStyle(.plain)
                        .contentMargins(.top, 0)
                        .listSectionSpacing(.compact)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .listRowSeparator(.hidden)
                        .listSectionSeparator(.hidden)

                        Spacer()
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
                            RoundedRectangle(cornerRadius: 17)
                                .fill(Color(red: 30/255, green: 94/255, blue: 54/255))
                        )
                        .disabled(name.isEmpty)
                    } //VStack
                    .frame(maxWidth: .infinity, alignment: .leading)
            } //if
            else {
                //Directo a ContentView si user ya existe
                //ContentView()
                TabViewSearch()
            }
        }
        .animation(.default, value: users.count) // smooth switch when user gets created
        .background {
            Image(colorScheme == .dark ? "backgroundDarkmode" : "background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .allowsHitTesting(false)
                .accessibilityHidden(true)
        }
    }
    
    private func createUser() {
        let user = User(name: name, avatar: selectedAvatar, city: selectedCity)
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



/*
 
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
                         
                         Picker("Avatar", selection: $selectedAvatar) {
                             ForEach(avatars, id: \.self) { avatar in
                                 Image(avatar)
                                     .resizable()
                                     .scaledToFit()
                                     .frame(width: 50)
                             }
                         }

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

 */
