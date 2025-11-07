//
//  Playground.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 05/11/25.
//

import FoundationModels
import Playgrounds

#Playground {
    if #available(iOS 26.0, *) {
        let instructions = """
            Your job is to give 2 places to visit depending on the city given by the user.
            """

        let session = LanguageModelSession(instructions: instructions)
        let prompt = "What are two cool places to go in Monterrey"
        let response = try await session.respond(to: prompt,
                                                 generating: PlaceMatch.self)
        // You can use `response` here, e.g., print or inspect it
        _ = response
    } else {
        // Fallback for earlier OS versions where LanguageModelSession/PlaceMatch are unavailable
        print("LanguageModelSession and PlaceMatch require iOS 26.0 or newer.")
    }
}
