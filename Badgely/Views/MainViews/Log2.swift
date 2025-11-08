import SwiftUI
import SwiftData

struct Log2: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var placesViewModel: PlacesViewModel
    
    @Query(sort: \Photo.date, order: .reverse) private var allPhotos: [Photo]
    @Query private var users: [User]
    
    //let photos: [UIImage]
    let user: User
    
    // Ajusta esto según cómo relaciones Photo con User en tu modelo
    var userPhotos: [Photo] {
        allPhotos.filter { photo in
            // Ejemplo si Photo tiene una propiedad `owner: User?`
            // photo.owner == user
            true // ← cámbialo por tu lógica real
        }
    }

    var avatar: String {
        user.avatar
    }
   
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            
            VStack(spacing: 10) {
                HStack {
                    Text("Álbum")
                        .font(.largeTitle).bold()
                    
                    Spacer()
                    
                    Text("México")
                        .font(.largeTitle)
                        
                }
                .padding(.horizontal)
                
                Image(user.avatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
            }
            .padding(.vertical)

            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(userPhotos) { photo in
                    
                    if let uiImage = UIImage(data: photo.photo) {
                        NavigationLink {
                            LogView(photo: photo)
                                .environmentObject(placesViewModel)
                        } label: {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 180, height: 260)
                                .clipped()
                                .background(.blue)
                        }
                    }
                    /*Image(uiImage: photos[index])
                        .resizable()
                        .scaledToFill()
                        .frame(width: 180, height: 260)
                        .clipped()
                        .background(.blue)*/
                }
            }
            .padding()
        }
    }
}

#Preview {
    
    // 1️⃣ Crear datos de ejemplo
    let previewPhoto1 = Photo(
        name: "Atardecer",
        photo: UIImage(systemName: "sunset.fill")!.pngData()!,
        badgeName: "Nature",
        place: "Plaza San Ignacio 5544 Jardines del Paseo, Monterrey Nuevo León 64910"
    )
    
    let previewPhoto2 = Photo(
        name: "Montaña Mon",
        photo: UIImage(systemName: "mountain.2.fill")!.pngData()!,
        badgeName: "Adventure",
        place: "Pedregal del coral 7016 Pedregal la Silla Monterrey Nuevo León 64898"
    )
    
    let previewPhoto3 = Photo(
        name: "Montaña Montaña",
        photo: UIImage(systemName: "balloon.fill")!.pngData()!,
        badgeName: "Adventure",
        place: "Pedregal del coral 7016 Pedregal la Silla Monterrey Nuevo León 64898"
    )
    
    let previewPhoto4 = Photo(
        name: "Atardecer",
        photo: UIImage(systemName: "sunset.fill")!.pngData()!,
        badgeName: "Nature",
        place: "Plaza San Ignacio 5544 Jardines del Paseo, Monterrey Nuevo León 64910"
    )
    
    let previewPhoto5 = Photo(
        name: "Montaña Mon",
        photo: UIImage(systemName: "mountain.2.fill")!.pngData()!,
        badgeName: "Adventure",
        place: "Pedregal del coral 7016 Pedregal la Silla Monterrey Nuevo León 64898"
    )
    
    let previewPhoto6 = Photo(
        name: "Cafe Cacao",
        photo: UIImage(systemName: "balloon.fill")!.pngData()!,
        badgeName: "Adventure",
        place: "Pedregal del coral 7016 Pedregal la Silla Monterrey Nuevo León 64898"
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
    let container = try! ModelContainer(for: Photo.self, configurations: config)
    
    // 3️⃣ Insertar los datos de ejemplo
    container.mainContext.insert(previewPhoto1)
    container.mainContext.insert(previewPhoto2)
    container.mainContext.insert(previewPhoto3)
    container.mainContext.insert(previewPhoto4)
    container.mainContext.insert(previewPhoto5)
    container.mainContext.insert(previewPhoto6)
    
    
    // 4️⃣ Devolver la vista usando el contenedor
    
    return Log2(user: previewUser)
        .modelContainer(container)

}

