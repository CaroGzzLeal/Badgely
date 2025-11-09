//
//  GalleryView.swift
//  Badgely
//
//  Created by Carolina Nicole Gonzalez Leal on 09/10/25.
//

import SwiftUI
import SwiftData
import MapKit

struct LogView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Photo.date, order: .reverse) var photos: [Photo]
    @Environment(\.dismiss) private var dismiss
    
    @Query var users: [User]
    @State var showDelete: Bool = false
    @State private var showDeleteAlert = false
    @State private var scrollID: Int?
    
    @State private var showLocationPicker = false
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var placesViewModel: PlacesViewModel
    
    let photo: Photo
    
    var body: some View {
        
        VStack(spacing: 28) {
            
            Text(photo.name)
                .font(.system(size: 30, weight: .bold))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: 320)
            
            if let uiImage = UIImage(data: photo.photo) {
                VStack {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 260)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                            //.fill(Color.blue)
                        )
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            openAppleMaps(place: photo.place)
                        }) {
                            Image(systemName: "location.circle")
                                .foregroundStyle(Color(colorScheme == .dark ? .white : .black))
                                .font(.system(size: 45))
                        }
                        
                        Text(photo.place)
                            .font(.system(size: 18))
                            .lineSpacing(7)
                    }
                }
                .alert(isPresented: $showDeleteAlert) {
                    Alert(title: Text("Eliminar foto"), message: Text("¿Estás seguro de eliminar esta foto?"), primaryButton: .destructive(Text("Eliminar")) {
                        deletePhoto(photo: photo)
                        showDelete = false
                        dismiss()
                    }, secondaryButton: .cancel())
                }
            }
            
        }
        .toolbar {
            if let uiImage = UIImage(data: photo.photo) {
                ShareLink(item: uiImage, preview: SharePreview(photo.name, image: uiImage)) {
                    Label("", systemImage: "square.and.arrow.up")
                        .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                        //.font(.system(size: 25))
                    
                }
            }
            Button(action: {
                showDeleteAlert = true
            }, label: {
                Image(systemName: "trash")
                    .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                    //.font(.system(size: 25))
                
            })
            
        }
        .padding(30)
        .background {
            Image(colorScheme == .dark ? "backgroundDarkmode" : "background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .allowsHitTesting(false)
                .accessibilityHidden(true)
        }
        
        
        //.scrollTargetBehavior(.paging)
        //.scrollPosition(id: $scrollID)
        
        //IndicatorView(imageCount: photos.count, scrollID: $scrollID)
        //    .padding(.bottom, 10)
    }
    
    func deletePhoto(photo: Photo) {
        guard let user = users.first else { return }
        
        guard let place = placesViewModel.places.first(where: {
            $0.name == photo.name || $0.address == photo.place
        }) else {
            print("No se encontró el lugar para la foto \(photo.name)")
            context.delete(photo)
            try? context.save()
            return
        }
        
        let type = place.type
        
        if let current = user.comunBadges[type], current > 0 {
            let newValue = current - 1
            
            if newValue > 0 {
                user.comunBadges[type] = newValue
            } else {
                user.comunBadges.removeValue(forKey: type)
            }
            
            let offset = categoryOffset(for: type)
            let frecuenteKey = "frecuente_\(36 + offset)"
            let maximoKey   = "maximo_\(43 + offset)"
            
            if newValue < 5 {
                if let idx = user.specialBadges.firstIndex(of: maximoKey) {
                    user.specialBadges.remove(at: idx)
                }
            }
            
            if newValue < 3 {
                if let idx = user.specialBadges.firstIndex(of: frecuenteKey) {
                    user.specialBadges.remove(at: idx)
                }
            }
        }
        
        if let badgeName = photo.badgeName, !badgeName.isEmpty {
            if let idx = user.badges.firstIndex(of: badgeName) {
                user.badges.remove(at: idx)
                user.responsibleBadges.remove(at: idx)
            }
        }
        
        context.delete(photo)
        try? context.save()
    }
    
    private func categoryOffset(for type: String) -> Int {
        switch type {
        case "cafeteria": return 0
        case "restaurante": return 1
        case "emblematico": return 2
        case "eventos": return 3
        case "voluntariado": return 4
        case "areasVerdes": return 5
        case "vidaNocturna": return 6
        default: return 6
        }
    }
    
    
    
    func openAppleMaps(place: String) {
        
        guard let matchingPlace = placesViewModel.places.first(where: { $0.address == place }) else {
            print("No se encontró un lugar con la dirección: \(place)")
            return
        }
        
        let coordinate = CLLocationCoordinate2D(
            latitude: matchingPlace.latitude,
            longitude: matchingPlace.longitude
        )
        print("Abriendo Apple Maps para:", matchingPlace.displayName)
        
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = matchingPlace.displayName
        
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
        ]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
}

extension UIImage: @retroactive Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { image in
            image.pngData() ?? Data()
        }
    }
}

struct IndicatorView: View {
    let imageCount: Int
    @Binding var scrollID: Int?
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<imageCount, id: \.self) { indicator in
                Button {
                    withAnimation {
                        scrollID = indicator
                    }
                } label: {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                        .foregroundStyle(indicator == (scrollID ?? 0)
                                         ? Color.white
                                         : Color(.lightGray))
                }
            }
        }
        .padding(7)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.lightGray))
                .opacity(0.2)
        )
    }
}

#Preview {
    // 1️⃣ Foto de ejemplo
    let previewPhoto = Photo(
        name: "Atardecer",
        photo: UIImage(systemName: "sunset.fill")!.pngData()!,
        badgeName: "Nature",
        place: "Plaza San Ignacio 5544 Jardines del Paseo, Monterrey Nuevo León 64910"
    )
    
    // 2️⃣ Usuario de ejemplo (para @Query users)
    let previewUser = User(
        name: "Carolina González",
        avatar: "profile3",
        city: "Monterrey",
        badges: [],
        specialBadges: []
    )
    
    // 3️⃣ Contenedor SwiftData en memoria con Photo y User
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: Photo.self, User.self,
        configurations: config
    )
    
    // 4️⃣ Insertar datos en el contexto
    container.mainContext.insert(previewUser)
    container.mainContext.insert(previewPhoto)
    
    // 5️⃣ PlacesViewModel de ejemplo
    let placesVM = PlacesViewModel()
    // Si quieres que el botón de Mapas tenga algo que encontrar:
    // placesVM.places = [
    //     Place(name: previewPhoto.name,
    //           displayName: "Plaza San Ignacio",
    //           latitude: 25.643,
    //           longitude: -100.31)
    // ]
    
    // 6️⃣ Devolver la vista
    return LogView(photo: previewPhoto)
        .modelContainer(container)
        .environmentObject(placesVM)
}
