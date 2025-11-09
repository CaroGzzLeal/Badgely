//
//  PlaceMatch.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 05/11/25.
//

import SwiftUI
import FoundationModels


@available(iOS 26.0, *) //solo funciona if apple intelligence is available“
@Generable // The @Generable macro makes your custom type compatible with the model.
struct PlaceMatch: Equatable {
    // The @Guide macro provides hints to the model about a property.
    @Guide(description: "A creative, single phrase title that summarizes the connection between the two places")
    let title: String
    
    @Guide(description: "The name of the first matched place")
    let place1Name: String
    
    @Guide(description: "The id number of the first matched place")
    let place1Id: Int
    
    @Guide(description: "The name of the second matched place")
    let place2Name: String
    
    @Guide(description: "The id number of the second matched place")
    let place2Id: Int
    
}

// for foundation model input, la estructura es mas basic q el json completito
struct SimplifiedPlace: Codable {
    let id: Int
    let name: String
    let description: String
    let type: String
}

// Compatibility helpers for UI previews and navigation.
// Note: The view now looks up full Place objects from the places array passed to it,
// so these helpers are no longer needed for navigation but kept for potential future use.
@available(iOS 26.0, *)
extension PlaceMatch {
    /// Optional subtitle for UI; not provided by the model generator by default.
    var subtitle: String? { nil }
}
