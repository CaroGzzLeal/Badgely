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
            Text(place.displayName)
            Image(place.image)
        }
    }
}
