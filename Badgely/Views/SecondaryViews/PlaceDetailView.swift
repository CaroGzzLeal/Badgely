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
    @State private var showingPopover = false
    
    @Query private var users: [User]
    
    private var user: User? { users.first }
    
    private var isFavorite: Bool {
        user?.favorites.contains(place.id) ?? false
    }
    
    var placeCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
    }
    
    var place: Place
    
    @State var showCamera = false
    
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 27.33, longitude: 100.00), // Center of the map
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // Zoom level
        )
    )
    
    var allShowingBadges: [String] {
        users[0].specialBadges + users[0].responsibleBadges
    }
    
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
                    .font(.title).bold()
                
                Text(place.description)
                    .font(.custom("SF Pro", size: 13))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .fontWidth(.condensed)
                    .lineSpacing(5)
                
                
                HStack {
                    
                    Image(systemName: "location.circle")
                        .foregroundStyle(Color(colorScheme == .dark ? .white : .black))
                    
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
                
                Map(initialPosition: makeMap(latitude: place.latitude, longitude: place.longitude))
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
                        .onTapGesture {
                            openAppleMaps()
                        }
                }
                
                HStack {
                    
                    Image(place.badge)
                        .resizable()
                        .scaledToFit()
                    //.frame(width: 85, height: 85)
                        .frame(width: 70, height: 70)
                    //.scaleEffect(1.1)
                        .clipped()
                        .opacity(users[0].badges.contains(place.badge) ? 1 : 0.2)
                    
                    Button(action: {
                        showingPopover = true
                    }, label: {
                        Image(place.responsibleBadge ?? "")
                        //.frame(width: 85, height: 85)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                        //.scaleEffect(1.1)
                            .clipped()
                            .opacity(place.responsibleBadge != nil && users[0].responsibleBadges.contains(place.responsibleBadge!) ? 1.0 : 0.2)
                    })
                    .popover(isPresented: $showingPopover) {
                        Text("Lleva tu termo y obten una insignia.")
                            .font(.headline)
                            .padding()
                            .frame(minWidth: 300, maxHeight: 300)
                            .presentationCompactAdaptation(.popover)
                    }
                    
                    Spacer()
                    
                    if !users[0].badges.contains(place.badge) || !(place.responsibleBadge != nil) && users[0].responsibleBadges.contains(place.responsibleBadge!) {
                        ZStack {
                            Button(action: {
                                showCamera = true
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(colorScheme == .dark ? .black : .white))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color(colorScheme == .dark ? .white : .black), lineWidth: 2)
                                        )
                                        .frame(width: 110, height: 50)
                                        .padding(.trailing, 20)
                                    
                                    Image(systemName: "camera")
                                        .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                                        .font(.system(size: 40))
                                        .padding(.trailing, 20)
                                    
                                }
                            }
                        }
                    }
                } //HStack
            }
            .padding(.horizontal, 20)
            
            Spacer()
            Spacer()
            
        }
        .fullScreenCover(isPresented: $showCamera) {
            AugmentedRealityContainer(place: place, selectedBadges: allShowingBadges, showCamera: $showCamera)
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
        let coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        print("Entre a la funcion para el lugar", place.displayName)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = place.displayName
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        
        mapItem.openInMaps(launchOptions: launchOptions)
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
