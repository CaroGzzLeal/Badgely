//
//  NearYouView.swift
//  Badgely
//
//  Created by Carolina Nicole Gonzalez Leal on 08/10/25.
//

import SwiftUI

struct NearYouView: View {
    
    @EnvironmentObject private var locationManager: LocationManager
    
    var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text("Lugares más cercanos a ti")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                if locationManager.nearestFive.isEmpty {
                    Text("Cargando lugares cercanos...")
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    
                    
                    RowView(places: locationManager.nearestFive)
                    /*ForEach(locationManager.nearestFive, id: \.name) { place in
                        VStack(alignment: .leading) {
                            Text(place.name)
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text("Lat: \(place.latitude), Lon: \(place.longitude)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .shadow(radius: 1)
                    }*/
                    
                }
                
                Spacer()
            }
            .padding()
        }
}

#Preview {
    NearYouView()
}
