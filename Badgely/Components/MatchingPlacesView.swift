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
    
    
    @Environment(\.colorScheme) var colorScheme
    
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if viewModel.isGenerating {
                HStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    Text("Te queremos recomendar lugares para visitar...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                //.frame(maxWidth: .infinity)
                //.padding()
                //.background(Color.secondary.opacity(0.1))
                //.cornerRadius(12)
            } else if let match = viewModel.placeMatch {
                ZStack(alignment: .bottomTrailing) {
                    VStack(alignment: .leading, spacing: 15) { //8
                        // Match Title
                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundColor(.yellow)
                                .font(.title3)
                            
                            Text(match.title)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                        
                        Divider()
                        
                        // Matched Places
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 4) {
                                Image("\(match.place1Type)\(match.place1Id)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    //.cornerRadius(15)
                                    //.padding(.horizontal, 7)
                                    .frame(width: 70, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .padding(5)
                                Text(match.place1Name)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                            .padding(12)
                            .background(Color(colorScheme == .dark ? Color(red: 28/255, green: 28/255, blue: 30/255) : Color(red: 245/255, green: 245/255, blue: 245/255)))
                            //.background(Color(red: 245/255, green: 245/255, blue: 245/255))
                            .cornerRadius(15)
                            
                            Image(systemName: "heart.fill")
                                .symbolRenderingMode(.hierarchical)
                                //.foregroundColor(Color(colorScheme == .dark ? Color(red: 28/255, green: 28/255, blue: 30/255) : Color(red: 245/255, green: 245/255, blue: 245/255)))
                                .font(.caption)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Image("\(match.place2Type)\(match.place2Id)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    //.cornerRadius(15)
                                    //.padding(.horizontal, 7)
                                    .frame(width: 70, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .padding(5)
                                
                                Text(match.place2Name)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                            //.aspectRatio(contentMode: .fit)
                            .padding(12)
                            .background(Color(colorScheme == .dark ? Color(red: 28/255, green: 28/255, blue: 30/255) : Color(red: 245/255, green: 245/255, blue: 245/255)))
                            //.background(Color(red: 245/255, green: 245/255, blue: 245/255))
                            .cornerRadius(15)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 8) // Extra padding for reload button
                    }
                    .padding()
                    
                    // Reload Button
                    Button(action: {
                        onReload()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color(colorScheme == .dark ? Color(red: 28/255, green: 28/255, blue: 30/255) : Color(red: 245/255, green: 245/255, blue: 245/255)))
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
                    }
                    .padding(12)
                }
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(10)
        
        .animation(.easeInOut, value: viewModel.isGenerating)
        .animation(.easeInOut, value: viewModel.placeMatch)
    }
}

@available(iOS 26.0, *)
#Preview {
    VStack {
        // Preview with mock data
        MatchingPlacesView(viewModel: {
            let vm = MatchingPlacesViewModel()
            return vm
        }(), onReload: {
            print("Reload tapped")
        })
    }
    .padding()
}
