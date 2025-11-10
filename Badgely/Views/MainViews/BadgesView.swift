//
//  BadgesView.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 07/10/25.
//
    import SwiftUI

    struct BadgesView: View {
        
        let user: User
        var totalBadges: Int {
            let validResponsible = user.responsibleBadges.filter { !$0.isEmpty }
            if user.city == "Guadalajara" || user.city == "Ciudad de México" {
                return 0
            }
            else {
                return user.badges.count + user.specialBadges.count + validResponsible.count
            }
        }
        @EnvironmentObject var placesViewModel: PlacesViewModel
        @State private var showLocationPicker = false

        var avatar: String {
            user.avatar
        }
        @State var showEdit: Bool = false
        
        @State var selectedCategory: String = "Comunes"
        let categories = ["Comunes", "Especiales", "Responsables"]
        
        let normalBadgesMonterrey: [String] = [
            "Bpartido_36", "Bpartido_37", "Bpartido_38", "badge000", "badge000",
            "Bareasverdes_26", "Bareasverdes_27", "Bareasverdes_28", "Bareasverdes_29", "Bareasverdes_30",
            "Bcafeteria_1", "Bcafeteria_2", "Bcafeteria_3", "Bcafeteria_4", "Bcafeteria_5",
            "Bemblematico_11", "Bemblematico_12", "Bemblematico_13", "Bemblematico_14", "Bemblematico_15",
            "Beventos_16", "Beventos_17", "Beventos_18", "Beventos_19", "Beventos_20",
            "Brestaurante_6", "Brestaurante_7", "Brestaurante_8", "Brestaurante_9", "Brestaurante_10",
            "Bvidanocturna_31", "Bvidanocturna_32", "Bvidanocturna_33", "Bvidanocturna_34", "Bvidanocturna_35",
            "Bvoluntariado_21", "Bvoluntariado_22", "Bvoluntariado_23", "Bvoluntariado_24", "Bvoluntariado_25"
        ]
        
        let specialBadgesMonterrey: [String] = [
            "frecuente_36", "maximo_43", //cafeterías
            "frecuente_37", "maximo_44", //restaurantes
            "frecuente_38", "maximo_45", //emblemático
            "frecuente_39", "maximo_46", //eventos
            "frecuente_40", "maximo_47", //voluntariado
            "frecuente_41", "maximo_48", //areas verdes
            "frecuente_42", "maximo_49", //vida nocturna
            "frecuente_43", "maximo_50" //partidos
        ]
        
        let responsibleBadgesMonterrey: [String] = [
            "bici_51", "bolsa_55", "bus_54", "carpool_53", "metro_52", "termo_50", "resp_56"
        ]
        
        let baseBadges: [String] = [
            "badge225", "badge226", "badge2000", "badge2000", "badge2000", // área verde
            "badge200", "badge201", "badge2000", "badge2000", "badge2000", // cafetería
            "badge210", "badge211", "badge2000", "badge2000", "badge2000", // emblemático
            "badge215", "badge216", "badge2000", "badge2000", "badge2000", // evento
            "badge205", "badge206", "badge2000", "badge2000", "badge2000", // restaurante
            "badge230", "badge231", "badge2000", "badge2000", "badge2000",// vida nocturna
            "badge220", "badge221", "badge2000", "badge2000", "badge2000" // voluntariado
        ]

        let partidoBadgesCDMX = [
            "Bpartido_236", "Bpartido_237", "Bpartido_238", "badge2000", "badge2000"
        ]

        let partidoBadgesGDL = [
            "Bpartido_136", "Bpartido_137", "Bpartido_138", "badge1000", "badge1000"
        ]
 
        let columnsNormal: [GridItem] = Array(repeating: .init(.flexible()), count: 5)
        let columnsSpecial: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
        let columnsResponsible: [GridItem] = Array(repeating: .init(.flexible()), count: 1)
        
        var chosenNormalBadges: [String] {
            if user.city == "Guadalajara" {
                return partidoBadgesGDL + baseBadges
            }
            else if user.city == "Ciudad de México" {
                return partidoBadgesCDMX + baseBadges
            }
            else {
                return normalBadgesMonterrey
            }
        }
        
        @State private var selectedImage: Int? = nil
        @State private var showPopover = false
        
        @Environment(\.colorScheme) var colorScheme
        
        var body: some View {
            NavigationStack {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(spacing: 10){
                        HStack{
                            VStack(alignment: .leading, spacing: 15){
                                Text(user.name)
                                    //.font(.largeTitle)
                                    //.bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(Color(colorScheme == .dark ? .white : .black))
                                    .fontWeight(.bold)
                                    .font(.system(size: 30))
                                    .font(.custom("SF Pro", size: 30))
                                    //.padding(.horizontal, 10)
                                
                                HStack{
                                    Text("\(totalBadges)")
                                        .font(.title).bold()
                                    
                                    Text("medallas")
                                        .font(.title)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            Button(action: {
                                showEdit = true
                            }, label: {
                                Image(user.avatar)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                            })
                        }
                        .padding(.top, -75)
                        
                        VStack {
                            Text("Recompensas")
                                .font(.title3.bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 5) {
                                    ForEach(1...4, id: \.self) { index in
                                        Button(action: {
                                            selectedImage = index
                                            showPopover = true
                                        }) {
                                            Image("recompensa\(index)")
                                                .resizable()
                                                .frame(width: 100, height: 100)
                                                .cornerRadius(15)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                            .sheet(isPresented: $showPopover) {
                                if let selectedImage = selectedImage {
                                    VStack {
                                        Image("codigo\(selectedImage)")
                                            .resizable()
                                            .scaledToFit()
                                            .padding()
                                        Button("Cerrar") {
                                            showPopover = false
                                        }
                                        .padding(15)
                                        .background(Color(.systemGray6))
                                        .foregroundColor(.black)
                                        .cornerRadius(15)
                                    }
                                }
                            }
                        }
                        
                        Picker("Categoría", selection: $selectedCategory) {
                            ForEach(categories, id: \.self) { category in
                                Text(category)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.vertical)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .layoutPriority(1)
                    .padding(.bottom, 10)
                    
                    if selectedCategory == "Comunes" {
                        ScrollView() {
                            LazyVGrid(columns: columnsNormal, alignment: .center, spacing: 10) {
                                ForEach(chosenNormalBadges,  id: \.self) { badgeName in
                                    let hasBadge = user.badges.contains(badgeName)
                                    Image(badgeName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 45, height: 45)
                                        .opacity(hasBadge ? 1.0 : 0.3)
                                        .grayscale(hasBadge ? 0 : 0.8)
                                        .animation(.easeInOut(duration: 0.3), value: hasBadge)
                                }
                            }
                        }
                    }
                    else if (selectedCategory == "Especiales") {
                        ScrollView() {
                            LazyVGrid(columns: columnsSpecial, alignment: .center, spacing: 10) {
                                ForEach(specialBadgesMonterrey,  id: \.self) { badgeName in
                                    let hasBadge = user.badges.contains(badgeName) || user.specialBadges.contains(badgeName)
                                    Image(badgeName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 45, height: 45)
                                        .opacity(hasBadge ? 1.0 : 0.3)
                                        .grayscale(hasBadge ? 0 : 0.8)
                                        .animation(.easeInOut(duration: 0.3), value: hasBadge)
                                }
                            }
                        }
                    }
                    
                    else {
                        ScrollView() {
                            LazyVGrid(columns: columnsResponsible, alignment: .center, spacing: 10) {
                                ForEach(responsibleBadgesMonterrey,  id: \.self) { badgeName in
                                    let hasBadge = user.badges.contains(badgeName) || user.responsibleBadges.contains(badgeName)
                                    Image(badgeName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 45, height: 45)
                                        .opacity(hasBadge ? 1.0 : 0.3)
                                        .grayscale(hasBadge ? 0 : 0.8)
                                        .animation(.easeInOut(duration: 0.3), value: hasBadge)
                                }
                            }
                        }
                    }
                }
                .padding()
                .fullScreenCover(isPresented: $showEdit, content: {
                    ChangeProfileView(user: user, avatar: avatar, showEdit: $showEdit)
                })
                .sheet(isPresented: $showLocationPicker) {
                    LocationPickerView(user: user, placesViewModel: placesViewModel)
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        if #available(iOS 26.0, *) {
                            Button {
                                showLocationPicker.toggle()
                            } label: {
                                HStack(spacing: 4) {
                                    Text(user.city)
                                        .font(.system(size: 18, weight: .bold))
                                    Image(systemName: "location")
                                        .font(.system(size: 18, weight: .bold))
                                }
                            }
                            .padding(10)
                            .glassEffect()
                        } else {
                            Button {
                                showLocationPicker.toggle()
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "location")
                                    Text(user.city)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

#Preview {
    
    let previewUser = User(
        name: "Carolina Gonzalez",
        avatar: "profile1",
        city: "Monterrey",
        badges: [],
        specialBadges: []
    )
    
    BadgesView(user: previewUser, selectedCategory: "Comunes")
}

