//
//  GalleryView.swift
//  Badgely
//
//  Created by Carolina Nicole Gonzalez Leal on 09/10/25.
//

import SwiftUI
import SwiftData

struct LogView: View {
    @Query var photos: [Photo]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(photos) { photo in
                    if let uiImage = UIImage(data: photo.photo) {
                        VStack {
                            ZStack {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .clipped()
                                    .cornerRadius(20)
                                    .shadow(radius: 5)
                                    .animation(.spring(), value: photos.count)
                                }
                        
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
                    }
                }
            }
        }
    }
}

extension UIImage: @retroactive Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { image in
            image.pngData() ?? Data()
        }
    }
}

#Preview {
    LogView()
}
