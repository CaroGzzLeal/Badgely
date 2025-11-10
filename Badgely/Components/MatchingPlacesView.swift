//
//  MatchingPlacesView.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 05/11/25.
//

import SwiftUI

@available(iOS 26.0, *)
struct MatchingPlacesView: View {
    @ObservedObject var viewModel: MatchingPlacesViewModel
    var onReload: () -> Void
    let places: [Place]
    
    @Environment(\.colorScheme) var colorScheme
    
    //get place segun ID
    private func getPlace(byId id: Int) -> Place? {
        return places.first(where: { $0.id == id })
    }
    
    var body: some View {
        MatchingCardContainer(showReloadButton: !viewModel.isGenerating && viewModel.placeMatch != nil, onReload: onReload) {
            contentView
                .redacted(reason: viewModel.isGenerating ? .placeholder : [])
                .opacity(viewModel.isGenerating ? 0.2 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: viewModel.isGenerating)
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        VStack(alignment: .center, spacing: 16) {
            titleSection
            
            placesSection
            
            bottomSection
        }
        .frame(maxWidth: .infinity)
        .padding(16)
    }
    
    //titulo time
    private var titleSection: some View {
        HStack(spacing: 8) {
            Image(systemName: "sparkles")
                .font(.title3)
                .foregroundColor(.purple.opacity(0.6))
            
            //Text(viewModel.placeMatch?.title ?? "Combo para ti")
            Text("Combo para ti")
                .font(.title3)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    
    //places section time
    private var placesSection: some View {
        ZStack {
            HStack(spacing: 16) {
                // Left Place
                if let place1 = getPlace(byId: viewModel.placeMatch?.place1Id ?? 1) {
                    placeCard(place: place1)
                } else {
                    placeholderCard(name: "Placeholder Place")
                }
                
                // Right Place
                if let place2 = getPlace(byId: viewModel.placeMatch?.place2Id ?? 6) {
                    placeCard(place: place2)
                } else {
                    placeholderCard(name: "Placeholder Place")
                }
            }
            
            //heart between matches
            heartIcon
        }
        .frame(maxWidth: .infinity)
    }
    
    private var bottomSection: some View {
        HStack(spacing: 8) {
            Text(viewModel.placeMatch?.title ?? "Combo para ti")
                .font(.headline)
                .fontWeight(.thin)
                .foregroundStyle(.primary)
                .padding(.trailing, 15)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    //card component
    @ViewBuilder
    private func placeCard(place: Place) -> some View {
        VStack(alignment: .center, spacing: 6) {
            if !viewModel.isGenerating {
                NavigationLink {
                    PlaceDetailView(place: place)
                } label: {
                    placeImage(place: place)
                }
            } else {
                placeImage(place: place)
            }
            
            Text(place.name)
                .font(place.name.count > 18 ? .caption : .subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .lineLimit(3)
                .truncationMode(.tail)
        }
        .frame(maxWidth: .infinity)
    }
    
    //placeholder card para loading time
    @ViewBuilder
    private func placeholderCard(name: String) -> some View {
        VStack(alignment: .center, spacing: 6) {
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 150, height: 100)
            
            Text(name)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    //image component inside card comp
    private func placeImage(place: Place) -> some View {
        Image(place.image)
            .resizable()
            .aspectRatio(4/3, contentMode: .fill)
            .frame(width: 150, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
        
    
    //icon
    private var heartIcon: some View {
        ZStack {
            /*Circle()
                .fill(Color(.systemBackground))
                .frame(width: 40, height: 40)
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
            */
            Image(systemName: "heart.fill")
                .foregroundColor(.white)
                .frame(width: 120, height: 60)
                .font(.system(size: 70, weight: .semibold))
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                .padding(.bottom, 15)
        }
    }
}

//card cointainaer
@available(iOS 26.0, *)
struct MatchingCardContainer<Content: View>: View {
    let showReloadButton: Bool
    let onReload: () -> Void
    @ViewBuilder let content: Content
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            content
            
            //reload button
            if showReloadButton {
                Button(action: onReload) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.purple.opacity(0.6))
                        .padding(8)
                        .background(Color(.white))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
                }
                .padding(12)
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.1),
                    Color.purple.opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 7)
    }
}

// PREVIEW
@available(iOS 26.0, *)
#Preview("With Match") {
    VStack {
        let sampleMatch = PlaceMatch(
            title: "Paseo y Café",
            place1Name: "Café Azul",
            place1Id: 1,
            place2Name: "Restaurante Central",
            place2Id: 6
        )
        
        MatchingPlacesView(
            viewModel: MatchingPlacesViewModel(mockMatch: sampleMatch),
            onReload: { print("Reload tapped") },
            places: Place.samples
        )
    }
}

@available(iOS 26.0, *)
#Preview("Loading State") {
    VStack {
        let viewModel = MatchingPlacesViewModel()
        
        MatchingPlacesView(
            viewModel: viewModel,
            onReload: { print("Reload tapped") },
            places: Place.samples
        )
    }
}

