//
//  PlaceDetailView.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 07/10/25.
//
import SwiftUI
import SwiftData
import MapKit

//Vista de detalle de cada place, cuando le haces click esto es lo que te muestra TO DO - DARLE DISEÑO
struct PlaceDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    
    @Query private var users: [User]
    
    private var user: User? { users.first }
    
    private var isFavorite: Bool {
        user?.favorites.contains(place.id) ?? false
    }
    
    var place: Place
    @State var showCamera = false
    
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 27.33, longitude: 100.00), // Center of the map
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // Zoom level
        )
    )
    
    var body: some View {
        
        VStack {
            
            Image(place.image)
                .resizable()
                .ignoresSafeArea()
                .frame(height: 180)
            
            Spacer()

            VStack(alignment: .leading, spacing: 15) {
                
                Spacer()
                Text(place.displayName)
                    //.font(.custom("SF Pro", size: 25))
                    .font(.title).bold()
                
                Text(place.description)
                    .font(.custom("SF Pro", size: 13))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .fontWidth(.condensed)
                    .lineSpacing(5)
                
                
                HStack {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "location.circle")
                            .foregroundStyle(Color(colorScheme == .dark ? .white : .black))
                    }
                    .foregroundColor(.black)
                    .font(.system(size: 40))
                    
                    Spacer()
                    
                    Text(place.address)
                        .font(.caption)
                        .fontWeight(.light)
                        .padding(.horizontal, 7)
                        .lineSpacing(5)
                        .font(.custom("SF Pro", size: 27))
                    
                }
                .padding(.horizontal, 15)
                
                Map(initialPosition: startPosition)
                    .frame(maxWidth: .infinity, maxHeight: 150)
                    .padding(5)
                    .mapStyle(.standard(elevation: .flat, emphasis: .muted))
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                
                HStack{
                    
                    
                    Button(action: {
                        //la imagen cambiaria si ya se tomo TODO
                    }) {
                        Image("testBadge") // NO EXISTE AHORITA
                            //.frame(width: 85, height: 85)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .scaleEffect(1.1)
                            .clipped()
                        
                    }
                    
                    if users[0].specialBadges.contains(place.specialBadge) {
                        Image("testBadge")
                            .resizable()
                            .scaledToFit()
                            //.frame(width: 85, height: 85)
                            .frame(width: 70, height: 70)
                            .scaleEffect(1.1)
                            .clipped()
                        
                    }
                    
                    Spacer()
                    
                    if !users[0].specialBadges.contains(place.specialBadge) {
                        ZStack {
                            Button(action: {
                                showCamera = true
                            }) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    //.frame(width: 120, height: 50)
                                    .frame(width: 100, height: 40)
                                    .shadow(radius: 4)
                                    .padding(.trailing, 20)
                                
                            }
                            
                            Image(systemName: "camera")
                                .foregroundColor(.black.opacity(0.80))
                                .font(.system(size: 40))
                                .padding(.trailing, 20)
                            
                        }
                    }
                } //HStack
            }
            .padding(.horizontal, 20)
            
            Spacer()
            Spacer()
            
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
