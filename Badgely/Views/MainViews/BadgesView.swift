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
            user.badges.count + user.specialBadges.count
        }
        var avatar: String {
            user.avatar
        }
        @State var showEdit: Bool = false
        
        @State var selectedCategory: String = "Comunes"
        let categories = ["Comunes", "Especiales", "Responsables"]
        
        let normalBadges: [String] = [
            "Bareasverdes_26", "Bareasverdes_27", "Bareasverdes_28", "Bareasverdes_29", "Bareasverdes_30",
            "Bcafeteria_1", "Bcafeteria_2", "Bcafeteria_3", "Bcafeteria_4", "Bcafeteria_5",
            "Bemblematico_11", "Bemblematico_12", "Bemblematico_13", "Bemblematico_14", "Bemblematico_15",
            "Beventos_16", "Beventos_17", "Beventos_18", "Beventos_19", "Beventos_20",
            "Brestaurante_6", "Brestaurante_7", "Brestaurante_8", "Brestaurante_9", "Brestaurante_10",
            "Bvidanocturna_31", "Bvidanocturna_32", "Bvidanocturna_33", "Bvidanocturna_34", "Bvidanocturna_35",
            "Bvoluntariado_21", "Bvoluntariado_22", "Bvoluntariado_23", "Bvoluntariado_24", "Bvoluntariado_25"
        ]
        
        let specialBadges: [String] = [
            "frecuente_36", "maximo_43",
            "frecuente_37", "maximo_44",
            "frecuente_38", "maximo_45",
            "frecuente_39", "maximo_46",
            "frecuente_40", "maximo_47",
            "frecuente_41", "maximo_48",
            "frecuente_42", "maximo_49"
        ]
        
        let responsibleBadges: [String] = [
            "bici_51", "bolsa_55", "bus_54", "carpool_53", "metro_52", "termo_50"
        ]
        
        let columnsNormal: [GridItem] = Array(repeating: .init(.flexible()), count: 5)
        let columnsSpecial: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
        let columnsResponsible: [GridItem] = Array(repeating: .init(.flexible()), count: 1)
        
        
        var body: some View {
            VStack {
                Button(action: {
                    showEdit = true
                }, label: {
                    Image(user.avatar)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180)
                })
                
                Text("\(user.name)")
                    .font(Font.largeTitle)
                    .bold()
                
                Text("\(totalBadges)")
                    .font(.title)
                
                Text("badges")
                    .font(.headline)
                
                Spacer()
                
                Picker("Categoría", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.vertical)
                
                if selectedCategory == "Comunes" {
                    LazyVGrid(columns: columnsNormal, alignment: .center, spacing: 10) {
                        ForEach(normalBadges,  id: \.self) { badgeName in
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
                else if (selectedCategory == "Especiales") {
                    LazyVGrid(columns: columnsSpecial, alignment: .center, spacing: 10) {
                        ForEach(specialBadges,  id: \.self) { badgeName in
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
                
                else {
                    LazyVGrid(columns: columnsResponsible, alignment: .center, spacing: 10) {
                        ForEach(responsibleBadges,  id: \.self) { badgeName in
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
                    Spacer()
                    Spacer()
                    Spacer()
                }
            }
            .padding()
            .fullScreenCover(isPresented: $showEdit, content: {
                ChangeProfileView(user: user, avatar: avatar, showEdit: $showEdit)
            })
        }
    }

#Preview {
    
    let previewUser = User(
        name: "Carolina González",
        avatar: "profile1",
        city: "Monterrey",
        badges: [],
        specialBadges: []
    )
    
    BadgesView(user: previewUser, selectedCategory: "Comunes")
}

