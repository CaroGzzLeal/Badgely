import SwiftUI
import SwiftData

struct Log2: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var placesViewModel: PlacesViewModel
    
    @Query(sort: \Photo.date, order: .reverse) private var allPhotos: [Photo]
    @Query private var users: [User]
    
    @State private var showLocationPicker = false
    
    //let user: User
    
    private var userPhotos: [Photo] {
        guard let user = users.first else { return [] }
        return allPhotos.filter { photo in
            photo.city == user.city
        }
    }

    private var user: User? {
        users.first
    }

    /*var avatar: String {
        user.avatar
    }*/
   
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                
                HStack(alignment: .top, spacing: 50) { //spacing 50
                    VStack(alignment: .leading) {
                        Text("Álbum")
                            .foregroundStyle(Color(colorScheme == .dark ? .white : .black))
                            .fontWeight(.bold)
                            .font(.system(size: 30))
                            .font(.custom("SF Pro", size: 30))
                            .padding(.trailing, 16)
                            //.background(Color(.gray))
                            
                        
                        Text("Tus memorias de \(user?.city ?? "México").")
                            .font(.headline)
                            .fontWeight(.thin)
                            .padding(.trailing, 16)
                            //.background(Color(.gray))
                    }
                    //.background(Color(.green))
                    //.padding(.horizontal)
                    
                    //Spacer()
                    
                    if let user = user {
                        Image(user.avatar)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .padding(.trailing,10)
                            //.background(Color(.gray))
                    }
                        
                }
                .padding(.trailing, 16)
                //.background(Color(.blue))
                //.padding(.vertical)
                
                
                if userPhotos.isEmpty {
                    
                    VStack {
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                                .italic()
                            Text("Aún no tienes fotos en \(user?.city ?? "México").")
                                .foregroundColor(.gray)
                                .italic()
                        }
                        
                        Spacer()
                    }
                    .frame(minHeight: 500)
                    
                    /*LazyVGrid(columns: columns) {
                        VStack(spacing: 16) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            Text("Aún no tienes fotos en \(user?.city ?? "México").")
                                .foregroundColor(.gray)
                                .italic()
                        }
                    }
                    .padding()
                     */
                    
                }
                else {
                    LazyVGrid(columns: columns) {
                        ForEach(userPhotos) { photo in
                            if let uiImage = UIImage(data: photo.photo) {
                                let placeForPhoto = placesViewModel.places.first { $0.name == photo.name }

                                NavigationLink {
                                    LogView(photo: photo)
                                        .environmentObject(placesViewModel)
                                } label: {
                                    PhotoCardView(
                                        image: uiImage,
                                        title: placeForPhoto?.displayName ?? photo.name,
                                        place: placeForPhoto,
                                        user: user
                                    )
                                }
                                .buttonStyle(.plain) // para que no ponga el azul feo del link
                            }
                        }
                    }
                    .padding()
                    //.background(Color(.red))
                }
            }
            //.background(Color(.red))
            // City change logic (same as ContentView and FavoritesView)
            .sheet(isPresented: $showLocationPicker) {
                if let user = users.first {
                    LocationPickerView(user: user, placesViewModel: placesViewModel)
                }
            }
            .onAppear {
                // Load places for user's city
                if let city = users.first?.city {
                    placesViewModel.loadPlaces(for: city)
                }
            }
            .onChange(of: users.first?.city) { oldValue, newValue in
                // Reload if city changes
                if let city = newValue {
                    placesViewModel.loadPlaces(for: city)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    if #available(iOS 26.0, *) {
                        Button {
                            showLocationPicker.toggle()
                        } label: {
                            HStack(spacing: 4) {
                                Text(users.first?.city ?? "Badgely")
                                    .font(.system(size: 18, weight: .bold))
                                Image(systemName: "location")
                                    .font(.system(size: 18, weight: .bold))
                            }
                        }
                        .padding(10)
                        .glassEffect()
                        
                    } else {
                        Button {
                            showLocationPicker.toggle()
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "location")
                                Text(users.first?.city ?? "Badgely")
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    
    // 1️⃣ Crear datos de ejemplo
    let previewPhoto1 = Photo(
        name: "Atardecer",
        photo: UIImage(systemName: "sunset.fill")!.pngData()!,
        badgeName: "Nature",
        respName: "Yolo",
        place: "Plaza San Ignacio 5544 Jardines del Paseo, Monterrey Nuevo León 64910",
        city: "Monterrey"
    )
    
    let previewPhoto2 = Photo(
        name: "Montaña Mon",
        photo: UIImage(systemName: "mountain.2.fill")!.pngData()!,
        badgeName: "Adventure",
        respName: "Yolo",
        place: "Pedregal del coral 7016 Pedregal la Silla Monterrey Nuevo León 64898",
        city: "Monterrey"
    )
    
    let previewPhoto3 = Photo(
        name: "Montaña Montaña",
        photo: UIImage(systemName: "balloon.fill")!.pngData()!,
        badgeName: "Adventure",
        respName: "Yolo",
        place: "Pedregal del coral 7016 Pedregal la Silla Monterrey Nuevo León 64898",
        city: "Monterrey"
    )
    
    let previewPhoto4 = Photo(
        name: "Atardecer",
        photo: UIImage(systemName: "sunset.fill")!.pngData()!,
        badgeName: "Nature",
        respName: "Yolo",
        place: "Plaza San Ignacio 5544 Jardines del Paseo, Monterrey Nuevo León 64910",
        city: "Monterrey"
    )
    
    let previewPhoto5 = Photo(
        name: "Montaña Mon",
        photo: UIImage(systemName: "mountain.2.fill")!.pngData()!,
        badgeName: "Adventure",
        respName: "Yolo",
        place: "Pedregal del coral 7016 Pedregal la Silla Monterrey Nuevo León 64898",
        city: "Monterrey"
    )
    
    let previewPhoto6 = Photo(
        name: "Cafe Cacao",
        photo: UIImage(systemName: "balloon.fill")!.pngData()!,
        badgeName: "Adventure",
        respName: "Yolo",
        place: "Pedregal del coral 7016 Pedregal la Silla Monterrey Nuevo León 64898",
        city: "Monterrey"
    )
    
    let previewUser = User(
        name: "Carolina Gonzalez",
        avatar: "profile3",
        city: "Monterrey",
        badges: [],
        specialBadges: []
    )
    
    // 2️⃣ Crear un contenedor temporal de SwiftData en memoria
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Photo.self, User.self, configurations: config)
    
    // 3️⃣ Insertar los datos de ejemplo (y el usuario para que @Query tenga datos)
    container.mainContext.insert(previewPhoto1)
    container.mainContext.insert(previewPhoto2)
    container.mainContext.insert(previewPhoto3)
    container.mainContext.insert(previewPhoto4)
    container.mainContext.insert(previewPhoto5)
    container.mainContext.insert(previewPhoto6)
    container.mainContext.insert(previewUser)
    
    // 4️⃣ Devolver la vista usando el contenedor y el EnvironmentObject necesario
    return Log2()
        .modelContainer(container)
        .environmentObject(PlacesViewModel())
}
