
//  ContentView.swift
//  Mariel
//
//  Created by Paul Perez on 06/10/25.
//
//Documento de Mariel que podemos usar de referencia. Lo unico que no he utilizado es el diseño del PlaceDetailView cuando haces click a cada place y te muestra una vista nueva. - Martha 7/10/25
import SwiftUI

struct BusinessData: Identifiable {
    let name: String
    let location: String
    let description: String
    let id = UUID()

    static func examples() -> [BusinessData] {
        [BusinessData(name: "amsterdam", location: "UBICACION AQUI", description: "DESCRIPCION LARGA AQUI"),
         BusinessData(name: "paris", location: "UBICACION AQUI", description: "DESCRIPCION LARGA AQUI"),
         BusinessData(name: "ghent", location: "UBICACION AQUI", description: "DESCRIPCION LARGA AQUI"),
         BusinessData(name: "cafe", location: "UBICACION AQUI", description: "DESCRIPCION LARGA AQUI"),
         BusinessData(name: "monte", location: "UBICACION AQUI", description: "DESCRIPCION LARGA AQUI")]

    }
}


struct BusinessCardView: View {
    let negocio: BusinessData

    var body: some View {
        NavigationLink(destination: BusinessInfoView(name: negocio.name,  location: negocio.location, description: negocio.description)) {
            Image(negocio.name)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.horizontal, 7)
        }
    }
}

struct BadgeView: View {
    var body: some View {
        Text("Hola")
    }
}
    
struct BusinessInfoView: View {
    let name: String
    let location: String
    let description: String

    
    @State private var navigate = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Image(name)
                    .resizable()
                    .scaledToFit()
                    
                Text(name)
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.bottom, 20)
                Text(description)
                    .font(.body)
                    .padding(.bottom, 20)
                Text(location)
                    .font(.body)
                    .padding(.bottom, 20)
                
                NavigationLink(destination: ContentView()) {
                    Text("Regresar a la Página Principal") // se cambiara a lo de badges
                        .font(.headline)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                        .background(.black.opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
            .padding()
            .navigationTitle("Info")
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("My Badgeds", systemImage: "person.crop.circle") {
                    navigate.toggle()
                }
            }
        }
        .sheet(isPresented: $navigate) {
           BadgesView()
        .presentationDetents([.medium,.large])
        }
    }
}

struct MarielView: View {
    
    let businessData = BusinessData.examples()
    let emojiData = EmojiData.examples()
    
    @State private var navigate = false

    @State private var searchText = ""

    var body: some View {
        VStack {
                NavigationStack {
                    ScrollView(.vertical) {
                        
                        LazyVStack(alignment: .leading) {
                            ScrollView(.horizontal) {
                                VStack{
                                    LazyHStack(spacing: 20) {
                                        ForEach(emojiData) { inspiration in
                                            EmojiCardView(emoji: inspiration)
                                        }
                                    }
                                }
                            }
                        }
                        
                        LazyVStack(alignment: .leading) {
                            Text("Opciones Verdes")
                                .font(.headline)
                                .padding(.horizontal, 7)
                            ScrollView(.horizontal) {
                                VStack{
                                    LazyHStack(spacing: 0) {
                                        ForEach(businessData) { inspiration in
                                            BusinessCardView(negocio: inspiration)
                                        }
                                    }
                                }
                            }
                        }
                        
                        LazyVStack(alignment: .leading) {
                            Text("Restaurantes")
                                .font(.headline)
                                .padding(.horizontal, 7)
                            ScrollView(.horizontal) {
                                VStack{
                                    LazyHStack(spacing: 0) {
                                        ForEach(businessData) { inspiration in
                                            BusinessCardView(negocio: inspiration)
                                        }
                                    }
                                }
                            }
                        }
                        
                        LazyVStack(alignment: .leading) {
                            Text("Cafes")
                                .font(.headline)
                                .padding(.horizontal, 7)
                            ScrollView(.horizontal) {
                                VStack{
                                    LazyHStack(spacing: 0) {
                                        ForEach(businessData) { inspiration in
                                            BusinessCardView(negocio: inspiration)
                                        }
                                    }
                                }
                            }
                        }
                        
                        LazyVStack(alignment: .leading) {
                            Text("Bar")
                                .font(.headline)
                                .padding(.horizontal, 7)
                            ScrollView(.horizontal) {
                                VStack{
                                    LazyHStack(spacing: 0) {
                                        ForEach(businessData) { inspiration in
                                            BusinessCardView(negocio: inspiration)
                                        }
                                    }
                                }
                            }
                        }
                    } // Scroll View
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button("My Badgeds", systemImage: "person.crop.circle") {
                                navigate.toggle()
                            }
                        }
                    }
                    .sheet(isPresented: $navigate) {
                       BadgeView()
                    .presentationDetents([.medium,.large])
                    }
                    .navigationTitle("Monterrey")
                    .navigationBarTitleDisplayMode(.inline)
                } // NavigationStack
            } // VStack
            .searchable(text: $searchText, prompt: "Busca con Badgley")
    } // body view
} // ContentView

#Preview {
    MarielView()
}
