//
//  NearYouView.swift
//  Badgely
//
//  Created by Carolina Nicole Gonzalez Leal on 08/10/25.
//

import SwiftUI

struct NearYouView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var locationManager: LocationManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Lugares más cercanos a ti")
                .font(.headline)
                .padding(.horizontal, 9)
                .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                .font(.system(size: 20))
            
            if locationManager.nearestFive.isEmpty {
                Text("Cargando lugares cercanos...")
                    .foregroundColor(.gray)
                    .italic()
            } else {
                RowView(places: locationManager.nearestFive)
            }
        }
    }
}

#Preview {
    NearYouView()
}
