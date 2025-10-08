//
//  PlaceDetailView.swift
//  Badgely
//
//  Created by Martha Mendoza y Mariel Perez on 07/10/25.
//
import SwiftUI





//Componente de row - TO DO crear un componente de cada info card, de cada restaurante card
struct RowView: View {
    let title: String
    let places: [Place]
    let rows = [
        GridItem(.adaptive(minimum: 150))
    ]
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows) {
                    ForEach(places) { place in
                        NavigationLink(destination: PlaceDetailView(place: place)) {
                            ZStack{
                                //Esto es el diseño de la card ahorita, deberia ser otro componente
                                Image(place.image)
                                    .resizable()
                                    .scaledToFill()
                                //.frame(width: 100, height: 100)
                                    .frame(width: 200, height: 150)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .padding(.horizontal, 7)
                                Text(place.displayName)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    
                            }
                        }
                    }
                }
                
            }
        }
    }
}
