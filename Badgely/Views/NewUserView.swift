//
//  NewUserView.swift
//  Badgely
//
//  Created by Carolina Nicole Gonzalez Leal on 07/11/25.
//

import SwiftUI
import SwiftData

struct NewUserView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    
    @EnvironmentObject var placesViewModel: PlacesViewModel
    @Environment(\.colorScheme) var colorScheme
    
    let cities = ["Monterrey", "Guadalajara", "Mexico City"]
    @State private var selectedCity = "Monterrey"
    
    let avatars = ["profile1", "profile2", "profile3", "profile4"]
    @State private var selectedAvatar = "profile1"
    @State private var avatarselected: String? = nil
    
    @State private var inputName: String = ""
    @State private var showPopover = false
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        if users.isEmpty {
            ZStack {
                Image(colorScheme == .dark ? "backgroundDarkmode" : "background")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .accessibilityHidden(true)
                ZStack {
                    Image(colorScheme == .dark ? "backgroundDarkmode" : "background")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                        .accessibilityHidden(true)
                    
                    
                    VStack(spacing: 25) {
                        Image("icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                        
                        Text("¡Bienvenido a la comunidad Badgely!")
                            .fontWeight(.bold)
                            .font(.title).bold()
                            .multilineTextAlignment(.center)
                            .font(.system(size: 32))
                            .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        VStack(spacing: 10) {
                            Text("Ingresa tu nombre:")
                                .foregroundStyle(Color(colorScheme == .dark ? .white : .black))
                                .fontWeight(.bold)
                                .font(.system(size: 20))
                            
                            TextField("", text: $inputName)
                                .textFieldStyle(.roundedBorder)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color(colorScheme == .dark ? .white : .black))
                                }
                                .font(.custom("SF Pro", size: 25))
                                .lineLimit(1)
                                .frame(width: 300)
                        }
                        
                        VStack(spacing: 10) {
                            Text("Ciudad de tu proximo destino:")
                                .foregroundStyle(Color(colorScheme == .dark ? .white : .black))
                                .fontWeight(.bold)
                                .font(.system(size: 20))
                            
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
                        
                        VStack(spacing: 10) {
                            Text("Selecciona tu avatar:")
                                .foregroundStyle(Color(colorScheme == .dark ? .white : .black))
                                .fontWeight(.bold)
                                .font(.system(size: 20))
                            
                            Button(action: {
                                showPopover.toggle()
                            }){
                                if let imageName = avatarselected {
                                    Image(imageName)
                                        .resizable()
                                        .frame(width: 110, height: 110)
                                }
                                else {
                                    Image("seleccionAvatar")
                                        .resizable()
                                        .frame(width: 110, height: 110)
                                }
                            }
                            .popover(isPresented: $showPopover) {
                                LazyVGrid(columns: columns) {
                                    ForEach(avatars, id: \.self) { name in
                                        Button(action: {
                                            avatarselected = name
                                            selectedAvatar = name
                                            showPopover = false
                                        }) {
                                            Image(name)
                                                .resizable()
                                                .frame(width: 110, height: 110)
                                        }
                                    }
                                }
                                .padding()
                                .frame(width: 300, height: 300)
                                .presentationCompactAdaptation(.popover)
                            }
                        }
                        
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
                                .fill(inputName.isEmpty ? .gray : Color(red: 30/255, green: 94/255, blue: 54/255))
                        )
                        .disabled(inputName.isEmpty)
                        
                    }
                }
                .onTapGesture {
                    hideKeyboard()
                }
            }
            .animation(.default, value: users.count)
        }
        else {
            TabViewSearch()
        }
    }
    
    private func createUser() {
        let user = User(name: inputName, avatar: selectedAvatar, city: selectedCity)
        modelContext.insert(user)
        do {
            try modelContext.save()
            print("User created: \(user.name) in \(user.city)")
        } catch {
            print("Error creating user: \(error.localizedDescription)")
        }
    }
}


extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}


#Preview {
    NewUserView()
}
