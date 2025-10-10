//
//  PlaceDetailView.swift
//  Badgely
//
//  Created by Martha Mendoza y Mariel Perez on 07/10/25.
//
import SwiftUI
import SwiftData




//Componente de row - TO DO crear un componente de cada info card, de cada restaurante card
struct RowView: View {
    let title: String
    let places: [Place]
    //let user: User? //?
    
    let rows = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows) {
                    ForEach(places) { place in
                        NavigationLink(destination: PlaceDetailView(place: place)) {
                            
                            CardView(place: place)
                        }
                    }
                }
                
            }
        }
    }
}


struct CardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    
    private var user: User? { users.first }
    private var isFavorite: Bool {
        user?.favorites.contains(place.id) ?? false
    }
    
    let place: Place
    
    var body: some View {
        ZStack{
            //Esto es el diseño de la card ahorita, deberia ser otro componente
            VStack(alignment: .leading) {
                
                
                Image(place.image)
                    .resizable()
                //.scaledToFill()
                    .aspectRatio(contentMode: .fill)
                //.frame(width: 100, height: 100)
                    .frame(width: 250, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(5)
                    .overlay(alignment: .topTrailing) {
                        Button {
                            toggleFavorite()
                        } label: {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .symbolRenderingMode(.hierarchical)
                                .padding(8)
                                .background(.white, in: Circle())  
                        }
                        .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
                    }
                    .clipped()
                
                HStack {
                    Text(place.displayName)
                        .foregroundStyle(.black)
                        .fontWeight(.bold)
                        .font(.system(size: 15))
                }
                    
            }
            .aspectRatio(contentMode: .fit)
            .padding(12)
            .background(Color(red: 245/255, green: 245/255, blue: 245/255))
            .cornerRadius(15)
            .padding(.horizontal, 7)
                
        }
    }
    
    private func toggleFavorite() {
        guard let user else { return }
        if let idx = user.favorites.firstIndex(of: place.id) {
            user.favorites.remove(at: idx)
        } else {
            user.favorites.append(place.id)
        }
        // Guardar explicitamente just to be sure
        try? modelContext.save()
    }
    
}




#Preview {
    let samplePlace = Place(
        id: 2,
        name: "Café Laurel",
        type: "cafeteria",
        address: "Av. del Roble 660-Local A2-111, Valle del Campestre, 66265 San Pedro Garza García, N.L.",
        lat: "25.648984986698732",
        long: "-100.35522425264874",
        description: "Restaurante casual de Grupo Pangea que ofrece comfort food para desayunar o comer. Con ambiente relajado y cocina abierta, destaca por sus chilaquiles, toasts, pastas, panadería artesanal y coctelería ligera.",
        badge: "badge",
        specialBadge: "specialBadge"
    )
    CardView(place: samplePlace)
}
