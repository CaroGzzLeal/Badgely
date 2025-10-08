//
//  PlaceDetailView.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 07/10/25.
//
import SwiftUI

//Vista de detalle de cada place, cuando le haces click esto es lo que te muestra TO DO - DARLE DISEÑO
struct PlaceDetailView: View {
    var place: Place
    var body: some View {
        VStack {
            Image(place.image)
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding()
            Text(place.displayName)
                .font(Font.largeTitle.bold())
            Text(place.description)
                .font(.subheadline)
            Text(place.address)
                .font(.subheadline)
            
            
        }
    }
}
