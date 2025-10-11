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
    
    var placeCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: Double(place.lat)!, longitude: Double(place.long)!)
    }

    
    var place: Place
    
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
                
                //Spacer()
                
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
                

                Map(initialPosition: makeMap(latitude: Double(place.lat), longitude: Double(place.long)))
                {
                    Marker(place.displayName, coordinate: placeCoordinate)
                }
                        .frame(maxWidth: .infinity, maxHeight: 150)
                        .padding(5)
                        .mapStyle(.standard(elevation: .flat, emphasis: .muted))
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .overlay {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                                .opacity(0.2)
//                                .frame(maxWidth: .infinity, maxHeight: 150)
                                .onTapGesture {
                                    openAppleMaps()
                                }
                        }

  
                
                
                //if place.badge  {
                HStack{
                    Button(action: {
                        //la imagen cambiaria si ya se tomo TODO
                    }) {
                        Image("testBadge") // NO EXISTE AHORITA
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .scaleEffect(1.1)
                            .clipped()
                        
                    }
                    
                    Button(action: {
                        //la imagen cambiaria si ya se tomo TODO
                    }) {
                        Image("testBadge")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
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
                                .frame(width: 100, height: 40)
                                .shadow(radius: 4)
                                .padding(.trailing, 20)
                            
                        }
                        
                        Image(systemName: "camera")
                            .foregroundColor(.black.opacity(0.80))
                            .font(.system(size: 40))
                            .padding(.trailing, 20)
                    } //ZStack
                } //HStack
            }
            .padding(.horizontal, 20)
            
            Spacer()
            Spacer()
            
        }// VStack
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
        } //.TOOLBAR
    } //body
    
   private func makeMap(latitude: Double?, longitude: Double?) -> MapCameraPosition {
            let lat = latitude ?? 0.0
            let long = longitude ?? 0.0
       
            return MapCameraPosition.region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: lat, longitude: long),
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                )
            )        }
    
    func openAppleMaps() {
        let coordinate = CLLocationCoordinate2D(latitude: Double(place.lat)!, longitude: Double(place.long)!)
        print("Entre a la funcion para el lugar", place.displayName)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = place.displayName
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]

        mapItem.openInMaps(launchOptions: launchOptions)
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
    
} //VIEW
