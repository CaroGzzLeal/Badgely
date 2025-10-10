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
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach(Array(photos.enumerated()), id: \.offset) { index, photo in
                    if let uiImage = UIImage(data: photo.photo) {
                        VStack {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .clipped()
                                .cornerRadius(20)
                                .frame(maxWidth: .infinity)
                                .shadow(radius: 10)
                                .padding()
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
                                })
                            
                            HStack {
                                Text(photo.name)
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                                
                                ShareLink(item: uiImage, preview: SharePreview(photo.name, image: uiImage)) {
                                    Label("", systemImage: "square.and.arrow.up")
                                        .font(.caption)
                                        .padding(6)
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(8)
                                }
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
    LogView()
}

/*
 {
 HStack {
 ForEach(photos) { photo in
 if let uiImage = UIImage(data: photo.photo) {
 VStack {
 Image(uiImage: uiImage)
 .resizable()
 .scaledToFill()
 .frame(width: 250, height: 400)
 .clipped()
 .cornerRadius(20)
 .shadow(radius: 5)
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
 })
 
 Text(photo.name)
 .font(.title)
 .fontWeight(.bold)
 .foregroundColor(.primary)
 .padding()
 
 HStack {
 Text(photo.date, format: .dateTime.day().month().year())
 .font(.caption)
 .foregroundColor(.secondary)
 
 ShareLink(item: uiImage, preview: SharePreview(photo.name, image: uiImage)) {
 Label("", systemImage: "square.and.arrow.up")
 .font(.caption)
 .padding(6)
 .background(.ultraThinMaterial)
 .cornerRadius(8)
 }
 }
 }
 .frame(width: 350)
 .alert(isPresented: $showDeleteAlert) {
 Alert(title: Text("Delete Photo"), message: Text("Are you sure you want to delete this photo?"), primaryButton: .destructive(Text("Delete")) {
 deletePhoto(photo: photo)
 showDelete = false
 }, secondaryButton: .cancel())
 }
 }
 }
 }
 }
 */
