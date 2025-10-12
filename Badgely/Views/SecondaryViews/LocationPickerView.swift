//
//  LocationPickerView.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 10/10/25.
//
import SwiftUI
import SwiftData

// Location picker view to change user's city
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
                    Text("Selecciona tu ciudad")
                } footer: {
                    Text("Los lugares se actualizarán automáticamente según tu selección")
                        .font(.caption)
                }
            }
            .navigationTitle("Cambiar ubicación")
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
