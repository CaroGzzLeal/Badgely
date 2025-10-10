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
    @Environment(\.modelContext) private var modelContext
    
    @Query private var users: [User]
    
    private var user: User? { users.first }
    
    private var isFavorite: Bool {
        user?.favorites.contains(place.id) ?? false
    }
    
    var place: Place
    @State var showCamera = false
    
    
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
                
                if users[0].specialBadges.contains(place.specialBadge) {
                    Text(place.specialBadge)
                }
                if !users[0].specialBadges.contains(place.specialBadge) {
                    Button("Add Photo") {
                        showCamera = true
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
                }
            }
            
            Spacer()
            //if place.badge  {
            HStack{
                Button(action: {
                //la imagen cambiaria si ya se tomo TODO
                }) {
                    Image("testBadge") // NO EXISTE AHORITA
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
        .fullScreenCover(isPresented: $showCamera) {
            AugmentedRealityContainer(place: place, selectedBadges: users[0].specialBadges, showCamera: $showCamera)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    toggleFavorite()
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .symbolRenderingMode(.hierarchical)
                }
                .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
            }
        }
    }
    
    private func toggleFavorite() {
        print("toggle function entered")
        guard let user else { return }
        if let idx = user.favorites.firstIndex(of: place.id) {
            user.favorites.remove(at: idx)
            print("removed")
        } else {
            user.favorites.append(place.id)
            print("added")
        }
        // Guardar explicitamente just to be sure
        try? modelContext.save()
        print("toggle success!")
    }
}
