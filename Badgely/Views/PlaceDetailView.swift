//
//  PlaceDetailView.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 07/10/25.
//
import SwiftUI
import SwiftData

//Vista de detalle de cada place, cuando le haces click esto es lo que te muestra TO DO - DARLE DISEÑO
struct PlaceDetailView: View {
    var place: Place
    @State var showCamera = false
    @Query private var users: [User]
    
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
            
            if users[0].specialBadges.contains(place.specialBadge) {
                Text(place.specialBadge)
            }
            
            Button("Add Photo") {
                showCamera = true
            }
            .font(.caption)
            .foregroundColor(.blue)
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
        }
        .fullScreenCover(isPresented: $showCamera) {
            AugmentedRealityContainer(place: place, selectedBadges: users[0].specialBadges, showCamera: $showCamera)
        }
    }
}
