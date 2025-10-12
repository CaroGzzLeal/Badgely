//
//  LocationPickerView.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 10/10/25.
//
import SwiftUI
import SwiftData

// cambiar user city
struct LocationPickerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var user: User
    let placesViewModel: PlacesViewModel
    
    let cities = ["Monterrey", "Guadalajara", "Mexico City"]
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(cities, id: \.self) { city in
                        Button {
                            user.city = city
                            try? modelContext.save()
                            placesViewModel.loadPlaces(for: city)
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "location.fill")
                                    .foregroundColor(.green)
                                Text(city)
                                    .foregroundColor(.primary)
                                Spacer()
                                if user.city == city {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                } header: {
                    Text("Select Your City")
                } footer: {
                    Text("Places will be updated based on your selected city")
                        .font(.caption)
                }
            }
            .navigationTitle("Change Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
    }
}
