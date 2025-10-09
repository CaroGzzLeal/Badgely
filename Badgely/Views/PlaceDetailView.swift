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
            Spacer()
                VStack(spacing: 30) {
                    
                    Text(place.displayName)
                        .font(Font.title.bold())
                        .padding(.horizontal, 10)
                    Image(place.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(15)
                        .background(Color(red: 0.5, green: 0.55, blue: 0.5))
                        .cornerRadius(15)
                        .padding(.horizontal, 10)
                    
                    Text(place.description)
                        .font(.subheadline)
                        .padding(.horizontal, 10)
                    Button(action: {
                        
                    }) {
                        Image(systemName: "location.circle")
                    }
                    .foregroundColor(.black)
                    .font(.system(size: 40))
                    Text(place.address)
                        .font(.subheadline)
                        .padding(.horizontal, 7)
                    //if place.badge  {
                    
                }
            Spacer()
            
            //if place.badge  {
            HStack{
                Button(action: {
                //la imagen cambiaria si ya se tomo TODO
                }) {
                    Image("testBadge")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 85, height: 85)
                        .scaleEffect(1.1)
                        .clipped()
                    
                }
                
                Button(action: {
                    //la imagen cambiaria si ya se tomo TODO
                }) {
                    Image("testBadge")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 85, height: 85)
                        .scaleEffect(1.1)
                        .clipped()
                }
                Spacer()
                
                ZStack {
                    Button(action: {
                    //apareceria la imagen en vez del icono de la camara TODO
                    }) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .frame(width: 120, height: 50)
                            .shadow(radius: 4)
                            .padding(.trailing, 20)

                    }
                    
                    Image(systemName: "camera")
                        .foregroundColor(.black.opacity(0.80))
                        .font(.system(size: 40))
                        .padding(.trailing, 20)
                }
            }
        }
    }
}
