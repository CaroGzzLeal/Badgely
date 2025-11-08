//
//  FoundationPruebaView.swift
//  Badgely
//
//  Created by Carolina Nicole Gonzalez Leal on 20/10/25.
//

import SwiftUI
import FoundationModels

struct FoundationPruebaView: View {
    
    @State private var prompt: String = ""
    @State private var reply: String = ""
    
    var body: some View {
        NavigationStack {
            
            VStack {
                TextField("Enter question", text: $prompt)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Anwser") {
                    let session = LanguageModelSession()
                    Task {
                        reply = try await session.respond(to: prompt).content
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(prompt.isEmpty)
                
                ScrollView {
                    Text(reply)
                }
            }
            .padding()
            .navigationTitle(Text("Learning foundation"))
        }
    }
}

#Preview {
    FoundationPruebaView()
}
