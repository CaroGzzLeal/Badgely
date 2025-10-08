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
    @State private var showAR = false
    @State private var capturedImage: UIImage?
    
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
            
            if let img = capturedImage {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 400)
                    .cornerRadius(12)
                    .shadow(radius: 6)
            } else {
                Text("")
            }
            
            Button("Add Photo") {
                showAR = true
            }
            .font(.caption)
            .foregroundColor(.blue)
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
        }
        .fullScreenCover(isPresented: $showAR) {
            ARCameraSheet(isPresented: $showAR, capturedImage: $capturedImage)
        }
    }
}
