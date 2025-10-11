//
//  GalleryView.swift
//  Badgely
//
//  Created by Carolina Nicole Gonzalez Leal on 09/10/25.
//

import SwiftUI
import SwiftData

struct LogView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Photo.date, order: .reverse) var photos: [Photo]
    @Query var users: [User]
    @State var showDelete: Bool = false
    @State private var showDeleteAlert = false
    @State private var scrollID: Int?
    
    @State private var showLocationPicker = false
    
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach(Array(photos.enumerated()), id: \.offset) { index, photo in
                    if let uiImage = UIImage(data: photo.photo) {
                        
                        VStack(spacing: 30) {
                            
                            Spacer()
                            Spacer()
                            Text(photo.name)
                                .font(.title).bold()
                            
                            VStack {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .clipped()
                                    .cornerRadius(20)
                                    .frame(width: 250)
                                    .shadow(radius: 10)
                                    .padding()
                                
                                
                                /*
                                 .onTapGesture {
                                 showDelete.toggle()
                                 }
                                 .overlay(content: {
                                 if showDelete {
                                 Button(action: {
                                 showDeleteAlert = true
                                 }, label: {
                                 Image(systemName: "trash.circle")
                                 .foregroundColor(.red)
                                 .font(.title)
                                 .padding()
                                 })
                                 }
                                 })*/
                                Spacer()
                                HStack {
                                    Button(action: {
                                        
                                    }) {
                                        Image(systemName: "location.circle")
                                            .foregroundStyle(Color(colorScheme == .dark ? .white : .black))
                                    }
                                    .foregroundColor(.black)
                                    .font(.system(size: 40))
                                    
                                    
                                    
                                    Text(photo.place)
                                        .font(.system(size: 15))
                                    //.fontWeight(.light)
                                        .padding(.horizontal, 7)
                                        .lineSpacing(5)
                                    
                                    
                                }
                                //.padding(.horizontal, 15)
                                
                                Spacer()
                                Spacer()
                                
                                HStack(spacing: 230) {
                                    
                                    ShareLink(item: uiImage, preview: SharePreview(photo.name, image: uiImage)) {
                                        Label("", systemImage: "square.and.arrow.up")
                                            .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                                            .font(.system(size: 40))
                                        
                                    }
                                    Button(action: {
                                        showDeleteAlert = true
                                    }, label: {
                                        Image(systemName: "trash")
                                            .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                                            .font(.system(size: 40))
                                        
                                    })
                                }
                                .alert(isPresented: $showDeleteAlert) {
                                    Alert(title: Text("Delete Photo"), message: Text("Are you sure you want to delete this photo?"), primaryButton: .destructive(Text("Delete")) {
                                        deletePhoto(photo: photo)
                                        showDelete = false
                                    }, secondaryButton: .cancel())
                                }
                            }
                            .containerRelativeFrame(.horizontal)
                            .scrollTransition(.animated, axis: .horizontal) { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1.0 : 0.6)
                                    .scaleEffect(phase.isIdentity ? 1.0 : 0.6)
                            }
                            .id(index)
                        }
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $scrollID)
        
        IndicatorView(imageCount: photos.count, scrollID: $scrollID)
            .padding(.bottom, 10)
    }
    
    func deletePhoto(photo: Photo) {
        
        if let badgeName = photo.badgeName, badgeName != "" {
            if let index = users[0].specialBadges.firstIndex(of: badgeName) {
                users[0].specialBadges.remove(at: index)
                print(users[0].specialBadges)
            }
        }
        
        let photoToDelete = photo
        context.delete(photoToDelete)
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
    // 1️⃣ Crear datos de ejemplo
    let previewPhoto1 = Photo(
        name: "Atardecer",
        photo: UIImage(systemName: "sunset.fill")!.pngData()!,
        badgeName: "Nature",
        place: "Plaza San Ignacio 5544 Jardines del Paseo, Monterrey Nuevo León 64910"
    )
    
    let previewPhoto2 = Photo(
        name: "Montaña",
        photo: UIImage(systemName: "mountain.2.fill")!.pngData()!,
        badgeName: "Adventure",
        place: "Pedregal del coral 7016 Pedregal la Silla Monterrey Nuevo León 64898"
    )
    
    let previewPhoto3 = Photo(
        name: "Montaña",
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
        name: "Montaña",
        photo: UIImage(systemName: "mountain.2.fill")!.pngData()!,
        badgeName: "Adventure",
        place: "Pedregal del coral 7016 Pedregal la Silla Monterrey Nuevo León 64898"
    )
    
    let previewPhoto6 = Photo(
        name: "Montaña",
        photo: UIImage(systemName: "balloon.fill")!.pngData()!,
        badgeName: "Adventure",
        place: "Pedregal del coral 7016 Pedregal la Silla Monterrey Nuevo León 64898"
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
    return LogView()
        .modelContainer(container)
}

