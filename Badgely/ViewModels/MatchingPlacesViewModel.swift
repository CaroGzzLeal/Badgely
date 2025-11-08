//
//  MatchingPlacesViewModel.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 05/11/25.
//
import Foundation
import FoundationModels
import SwiftUI

@available(iOS 26.0, *)
@MainActor
final class MatchingPlacesViewModel: ObservableObject {
    @Published private(set) var placeMatch: PlaceMatch?
    @Published private(set) var isGenerating: Bool = false
    @Published private(set) var error: Error?
    

    // Memory of previously matched place IDs
    @Published var excludedPlaceIds: Set<Int> = []


    // Create a new session with the language model.
    private var session: LanguageModelSession?
    // Add a model instance
    private let model = SystemLanguageModel.default
    private var initializationFailed = false
    private let instructions = """
        Your job is to analyze a list of places and select two that share a similar vibe, are related, or have something in common.
        
        The two places must be from different categories.
        Create a creative, single-phrase title that captures their connection.
        Focus on finding meaningful connections like atmosphere, target audience, cultural significance, or experiential similarities.
        """
    
    init() {
        //inicializa session solo si el model es available
        guard case .available = model.availability else {
            print("Foundation Models not available during init - availability: \(model.availability)")
            initializationFailed = true
            return
        }
        // initializing the LanguageModelSession
        self.session = LanguageModelSession(instructions: instructions)
    }
    
    // volver a hacer session cuando se refreshea
    private func resetSession() {
        guard case .available = model.availability else { return }
        session = LanguageModelSession(instructions: instructions)
    }
    
    // check if Foundation Models avaiable
    var isModelAvailable: Bool {
        guard !initializationFailed else { return false }
        if case .available = model.availability {
            return session != nil
        }
        return false
    }
    
    // prewarm model * mejora performance
    func prewarmModel() {
        guard isModelAvailable, let session = session else {
            print("Foundation Models not available, skipping prewarm")
            return
        }
        session.prewarm()
    }

    // Clear excluded IDs if needed (e.g., when user wants to reset)
    func resetExcludedPlaces() {
        excludedPlaceIds.removeAll()
    }
    
    //Match entre 2 places
    func generateMatch(from allPlaces: [Place], visitedBadges: [String]) async {
        print("   Model availability: \(model.availability)")
        
        guard isModelAvailable else {
            print("Foundation Models is not available")
            return
        }
        
        //Reset session to clear context window before each generation
        print("Resetting session to clear context window...")
        resetSession()
        
        guard let freshSession = session else {
            print("Failed to reset session")
            return
        }
        print("Fresh session created :)")
        
        isGenerating = true
        error = nil
        
        do {
            //filtro segun criteria
            let eligiblePlaces = filterEligiblePlaces(from: allPlaces, visitedBadges: visitedBadges, excludedIds: excludedPlaceIds)
            
            print("First list eligible places: ", eligiblePlaces.map { " \($0.name) \($0.type) \($0.id)" })
            
            guard eligiblePlaces.count >= 2 else {
                print("Not enough eligible places to create a match")
                isGenerating = false
                return
            }
            
            // Convert to simplified format for Foundation Models
            let simplifiedPlaces = eligiblePlaces.map { place in
                SimplifiedPlace(
                    id: place.id,
                    name: place.name,
                    description: place.description,
                    type: place.type
                )
            }
            
            print("\nPreparing prompt with \(simplifiedPlaces.count) places:")


            
            for place in simplifiedPlaces {
                print("- \(place.name) (\(place.type) \(place.id)")
            }

            // Build excluded list text for prompt
            let excludedListText = excludedPlaceIds.isEmpty ? "" : """
            
            IMPORTANT: Do NOT select any of these previously matched place IDs:
            \(excludedPlaceIds.map { String($0) }.joined(separator: ", "))
            """
            
            //crear prompt
            let placesDescription = simplifiedPlaces.map { place in
                "- \(place.name) (Type: \(place.type))\n  Description: \(place.description) Id: \(place.id)"
            }.joined(separator: "\n")
            
            let promptText = """
            Here is a list of places to choose from:
            \(placesDescription)
            \(excludedListText)
            
            Select exactly two places from different categories that share something in common and could make a great combo for a touristic activity.
            Please provide the ids, names, and types of the two selected places.
            Generate a creative title that captures their connection.
            """
            
            print("\nSending prompt to Foundation Models...")
            print("Prompt length: \(promptText.count) characters")
            print("Generation options: greedy sampling")
            
            // Generate the match
            let response = try await freshSession.respond(
                to: promptText,
                generating: PlaceMatch.self,
                options: GenerationOptions(sampling: .greedy)
            )
            
            print("\nReceived response from Foundation Models:")
            print("Title: \(response.content.title)")
            print("Place 1: \(response.content.place1Name)")
            print("Place 2: \(response.content.place2Name)")
            
            //print("Place 1 type and id: \(response.content.place1Type) and \(response.content.place1Id)")
            //print("Place 2 type and id: \(response.content.place2Type) and \(response.content.place2Id)")
            // Add the matched place IDs to excluded set
            excludedPlaceIds.insert(response.content.place1Id)
            excludedPlaceIds.insert(response.content.place2Id)

            self.placeMatch = response.content
            print("Match generated successfully")
            
        } catch {
            self.error = error
            print("\nError generating match: \(error.localizedDescription)")
            
            // Check if this is a model availability issue
            if !isModelAvailable {
                print("\nFoundation Models is not available. This feature requires:")
                print("- iOS 26.0 or later")
                print("- Apple Intelligence enabled in Settings")
                print("- A supported device (M1+ Mac or A17 Pro+ iPhone)")
                print("- Model assets downloaded")
            }
        } //do
        
        isGenerating = false
        print("=== APPLE INTELLIGENCE GENERATION END ===\n")
    } // fun gen match
    
    //Filter function para filtrar places que no han sido visitados y prepare for matching
    private func filterEligiblePlaces(from allPlaces: [Place], visitedBadges: [String], excludedIds: Set<Int>) -> [Place] {
        print("Starting place filtering...")
        print("Total places: \(allPlaces.count)")
        print("Visited badges: \(visitedBadges.count)")
        print("Excluded IDs: \(excludedIds.count)")

        // Get places where user hasn't collected the badge
        let unvisitedPlaces = allPlaces.filter { place in
            !visitedBadges.contains(place.badge)
        }

        // Filter out previously matched places
        let notExcluded = unvisitedPlaces.filter { place in
            !excludedIds.contains(place.id)
        }
        
        print("Unvisited places: \(unvisitedPlaces.count)")
        print("Not excluded places: \(notExcluded.count)")

        // Group by type to ensure we have multiple categories
        let groupedByType = Dictionary(grouping: notExcluded, by: { $0.type }) // before it was unvisitedPlaces
        
        print("Categories found:")
        for (type, places) in groupedByType.sorted(by: { $0.key < $1.key }) {
            print("      • \(type): \(places.count) places")
        }
        
        guard groupedByType.count >= 2 else {
            print("Not enough categories (\(groupedByType.count)) - need at least 2")
            return []
        }
        
        // Select up to 3 places from each category to ensure diversity
        // This prevents one category from dominating the selection
        var balancedPlaces: [Place] = []
        for (type, places) in groupedByType {
            let selectedCount = min(3, places.count)
            balancedPlaces.append(contentsOf: Array(places.prefix(selectedCount)))
        }
        
        print("Selected \(balancedPlaces.count) balanced places across \(groupedByType.count) categories")
        
        print("Eligible place ids sent:", balancedPlaces.map { " \($0.name) \($0.type) \($0.id)" })
        
        return balancedPlaces
    }
}
